import AppKit
import Carbon.HIToolbox

// Menu-bar agent for yabai:
//  • status item = current Desktop name; dropdown = a row per Desktop (index
//    pill + app icons, click to focus).
//  • global hotkey (⌃⌥Space) → a fuzzy window switcher across all Desktops.
// All data via `yabai -m query`.

let yabaiPath = "/opt/homebrew/bin/yabai"

@discardableResult
func yabai(_ args: [String]) -> Data {
    let proc = Process()
    proc.executableURL = URL(fileURLWithPath: yabaiPath)
    proc.arguments = args
    let out = Pipe()
    proc.standardOutput = out
    proc.standardError = Pipe()
    do { try proc.run() } catch { return Data() }
    let data = out.fileHandleForReading.readDataToEndOfFile()
    proc.waitUntilExit()
    return data
}

func decode<T: Decodable>(_ type: T.Type, _ data: Data) -> T? {
    try? JSONDecoder().decode(T.self, from: data)
}

struct Space: Decodable {
    let index: Int
    let label: String
    let display: Int
    let hasFocus: Bool
    let windows: [Int]
    enum CodingKeys: String, CodingKey {
        case index, label, display, windows
        case hasFocus = "has-focus"
    }
    var name: String { label.isEmpty ? "\(index)" : label }
}

struct Window: Decodable {
    let id: Int
    let app: String
    let title: String
    let pid: Int
    let space: Int
}

// ─────────────────────────────────────────────────────────────────────────────
// Window switcher
// ─────────────────────────────────────────────────────────────────────────────
final class KeyPanel: NSPanel { override var canBecomeKey: Bool { true } }

// One switcher result: [icon]  App  title(dim, truncated) ........ [desktop badge]
// Transparent — the table draws the selection behind it.
final class WindowRow: NSView {
    private let icon: NSImage?
    private let app: String
    private let title: String
    private let desktop: String

    init(icon: NSImage?, app: String, title: String, desktop: String) {
        self.icon = icon; self.app = app; self.title = title; self.desktop = desktop
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        let h = bounds.height
        icon?.draw(in: NSRect(x: 16, y: (h - 18) / 2, width: 18, height: 18))

        // desktop badge, right-aligned
        let badgeAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11, weight: .medium),
            .foregroundColor: NSColor.secondaryLabelColor]
        let bSize = (desktop as NSString).size(withAttributes: badgeAttrs)
        let pad: CGFloat = 7
        let badge = NSRect(x: bounds.width - 16 - bSize.width - pad * 2,
                           y: (h - 18) / 2, width: bSize.width + pad * 2, height: 18)
        NSColor.quaternaryLabelColor.setFill()
        NSBezierPath(roundedRect: badge, xRadius: 5, yRadius: 5).fill()
        (desktop as NSString).draw(at: NSPoint(x: badge.minX + pad, y: (h - bSize.height) / 2),
                                   withAttributes: badgeAttrs)

        // app name (semibold)
        let appAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13, weight: .semibold),
            .foregroundColor: NSColor.labelColor]
        let appStr = app as NSString
        let appW = appStr.size(withAttributes: appAttrs).width
        let textX: CGFloat = 46
        let textY = (h - 16) / 2
        appStr.draw(at: NSPoint(x: textX, y: textY), withAttributes: appAttrs)

        // title (dim, truncates before the badge)
        guard !title.isEmpty else { return }
        let titleX = textX + appW + 8
        let maxW = badge.minX - 14 - titleX
        guard maxW > 24 else { return }
        let para = NSMutableParagraphStyle(); para.lineBreakMode = .byTruncatingTail
        (title as NSString).draw(in: NSRect(x: titleX, y: textY, width: maxW, height: 18),
            withAttributes: [.font: NSFont.systemFont(ofSize: 13),
                             .foregroundColor: NSColor.secondaryLabelColor,
                             .paragraphStyle: para])
    }
}

final class Switcher: NSObject, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, NSWindowDelegate {
    private let panel = KeyPanel(contentRect: NSRect(x: 0, y: 0, width: 560, height: 360),
                                 styleMask: [.borderless, .nonactivatingPanel],
                                 backing: .buffered, defer: false)
    private let field = NSTextField()
    private let table = NSTableView()
    private var all: [(w: Window, sub: String)] = []
    private var shown: [(w: Window, sub: String)] = []

    override init() {
        super.init()
        panel.level = .floating
        panel.hasShadow = true
        panel.isMovable = false
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.delegate = self

        // Vibrant background → labelColor renders right + looks like a palette.
        let blur = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 560, height: 360))
        blur.material = .menu
        blur.blendingMode = .behindWindow
        blur.state = .active
        blur.wantsLayer = true
        blur.layer?.cornerRadius = 12
        blur.layer?.masksToBounds = true
        panel.contentView = blur

        let mag = NSImageView(frame: NSRect(x: 16, y: 327, width: 20, height: 20))
        mag.image = NSImage(systemSymbolName: "magnifyingglass", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(pointSize: 16, weight: .medium))
        mag.contentTintColor = .secondaryLabelColor
        mag.imageAlignment = .alignCenter
        blur.addSubview(mag)

        field.frame = NSRect(x: 46, y: 316, width: 498, height: 32)
        field.font = .systemFont(ofSize: 18)
        field.placeholderString = "Switch to window…"
        field.isBordered = false
        field.drawsBackground = false
        field.focusRingType = .none
        field.delegate = self
        blur.addSubview(field)

        let line = NSBox(frame: NSRect(x: 0, y: 312, width: 560, height: 1))
        line.boxType = .separator
        blur.addSubview(line)

        let scroll = NSScrollView(frame: NSRect(x: 0, y: 0, width: 560, height: 310))
        scroll.hasVerticalScroller = false       // hidden — arrow keys still scroll
        scroll.drawsBackground = false
        let col = NSTableColumn(identifier: .init("c"))
        col.width = 560; col.minWidth = 560; col.maxWidth = 560  // pinned → titles truncate
        table.addTableColumn(col)
        table.headerView = nil
        table.rowHeight = 32
        table.backgroundColor = .clear
        table.style = .fullWidth
        table.columnAutoresizingStyle = .noColumnAutoresizing
        table.dataSource = self
        table.delegate = self
        table.action = #selector(rowClicked)
        table.target = self
        table.doubleAction = #selector(focusSelected)
        scroll.documentView = table
        blur.addSubview(scroll)
    }

    func toggle() { panel.isVisible ? hide() : show() }

    private func show() {
        guard let wins = decode([Window].self, yabai(["-m", "query", "--windows"])) else { return }
        let spaces = decode([Space].self, yabai(["-m", "query", "--spaces"])) ?? []
        let nameBy = Dictionary(spaces.map { ($0.index, $0.name) }, uniquingKeysWith: { a, _ in a })
        all = wins.filter { !$0.app.isEmpty }.map { ($0, nameBy[$0.space] ?? "\($0.space)") }
        field.stringValue = ""
        filter("")
        if let s = NSScreen.main {
            panel.setFrameOrigin(NSPoint(x: s.frame.midX - 280, y: s.frame.midY - 100))
        }
        NSApp.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
        panel.makeFirstResponder(field)
    }

    private func hide() { panel.orderOut(nil) }

    private func filter(_ q: String) {
        let q = q.lowercased()
        shown = q.isEmpty ? all : all.filter {
            $0.w.app.lowercased().contains(q) || $0.w.title.lowercased().contains(q)
        }
        table.reloadData()
        if !shown.isEmpty { select(0) }
    }

    private func select(_ row: Int) {
        table.selectRowIndexes([row], byExtendingSelection: false)
        table.scrollRowToVisible(row)
    }

    @objc private func focusSelected() {
        let row = table.selectedRow
        guard row >= 0, row < shown.count else { return }
        _ = yabai(["-m", "window", "--focus", "\(shown[row].w.id)"])
        hide()
    }
    @objc private func rowClicked() { if table.clickedRow >= 0 { focusSelected() } }

    // typing → filter
    func controlTextDidChange(_ obj: Notification) { filter(field.stringValue) }

    // arrows / enter / esc while the field has focus
    func control(_ c: NSControl, textView: NSTextView, doCommandBy sel: Selector) -> Bool {
        switch sel {
        case #selector(NSResponder.moveDown(_:)):
            select(min(shown.count - 1, table.selectedRow + 1)); return true
        case #selector(NSResponder.moveUp(_:)):
            select(max(0, table.selectedRow - 1)); return true
        case #selector(NSResponder.insertNewline(_:)): focusSelected(); return true
        case #selector(NSResponder.cancelOperation(_:)): hide(); return true
        default: return false
        }
    }

    func windowDidResignKey(_ n: Notification) { hide() }

    // table
    func numberOfRows(in t: NSTableView) -> Int { shown.count }
    func tableView(_ t: NSTableView, viewFor col: NSTableColumn?, row: Int) -> NSView? {
        let item = shown[row]
        let icon = NSRunningApplication(processIdentifier: pid_t(item.w.pid))?.icon
        return WindowRow(icon: icon, app: item.w.app, title: item.w.title, desktop: item.sub)
    }
}

// ⌃⌥Space global hotkey (no Accessibility permission needed). ponytail: globals
// because there's exactly one hotkey; change the keycode/mods below to rebind.
private var hotKeyRef: EventHotKeyRef?
private var onHotKey: (() -> Void)?

func installHotKey(_ action: @escaping () -> Void) {
    onHotKey = action
    var spec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                             eventKind: OSType(kEventHotKeyPressed))
    InstallEventHandler(GetApplicationEventTarget(),
                        { _, _, _ in onHotKey?(); return noErr }, 1, &spec, nil, nil)
    let id = EventHotKeyID(signature: OSType(0x59425357), id: 1)
    RegisterEventHotKey(UInt32(kVK_Space), UInt32(controlKey | optionKey),
                        id, GetApplicationEventTarget(), 0, &hotKeyRef)
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu-bar item + per-Desktop rows
// ─────────────────────────────────────────────────────────────────────────────
final class SpaceRow: NSView {
    private let space: Space
    private let icons: [NSImage]
    private let onClick: (String) -> Void

    init(_ space: Space, icons: [NSImage], onClick: @escaping (String) -> Void) {
        self.space = space; self.icons = icons; self.onClick = onClick
        super.init(frame: NSRect(x: 0, y: 0, width: 300, height: 30))
    }
    required init?(coder: NSCoder) { fatalError() }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds,
            options: [.mouseEnteredAndExited, .activeInActiveApp], owner: self))
    }
    override func mouseEntered(with e: NSEvent) { needsDisplay = true }
    override func mouseExited(with e: NSEvent) { needsDisplay = true }
    override func mouseUp(with e: NSEvent) {
        enclosingMenuItem?.menu?.cancelTracking()
        onClick(space.name)
    }

    override func draw(_ dirtyRect: NSRect) {
        let hot = enclosingMenuItem?.isHighlighted ?? false
        if hot {
            NSColor.selectedContentBackgroundColor.setFill()
            NSBezierPath(roundedRect: bounds.insetBy(dx: 5, dy: 2), xRadius: 6, yRadius: 6).fill()
        }
        let fg: NSColor = hot ? .white : .labelColor
        let pill = NSRect(x: 12, y: 6, width: 18, height: 18)
        (space.hasFocus ? NSColor.controlAccentColor : NSColor.tertiaryLabelColor).setFill()
        NSBezierPath(roundedRect: pill, xRadius: 5, yRadius: 5).fill()
        drawCentered("\(space.index)", in: pill, color: .white, size: 11)
        drawText(space.name, at: NSPoint(x: 38, y: 7), color: fg, size: 13, bold: space.hasFocus)
        var x = bounds.width - 10 - 18
        for img in icons.prefix(7).reversed() {
            img.draw(in: NSRect(x: x, y: 6, width: 18, height: 18))
            x -= 21
        }
    }

    private func drawText(_ s: String, at p: NSPoint, color: NSColor, size: CGFloat, bold: Bool) {
        let f = bold ? NSFont.boldSystemFont(ofSize: size) : NSFont.systemFont(ofSize: size)
        (s as NSString).draw(at: p, withAttributes: [.font: f, .foregroundColor: color])
    }
    private func drawCentered(_ s: String, in r: NSRect, color: NSColor, size: CGFloat) {
        let a: [NSAttributedString.Key: Any] =
            [.font: NSFont.boldSystemFont(ofSize: size), .foregroundColor: color]
        let sz = (s as NSString).size(withAttributes: a)
        (s as NSString).draw(at: NSPoint(x: r.midX - sz.width/2, y: r.midY - sz.height/2), withAttributes: a)
    }
}

final class SpacesController: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private let switcher = Switcher()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .bold)

        let menu = NSMenu()
        menu.delegate = self
        statusItem.menu = menu

        updateTitle()
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(updateTitle),
            name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateTitle()
        }
        installHotKey { [weak self] in self?.switcher.toggle() }
    }

    @objc func updateTitle() {
        let space = decode(Space.self, yabai(["-m", "query", "--spaces", "--space"]))
        statusItem.button?.title = space?.name ?? "—"
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()
        guard let spaces = decode([Space].self, yabai(["-m", "query", "--spaces"])),
              let windows = decode([Window].self, yabai(["-m", "query", "--windows"])) else {
            menu.addItem(withTitle: "yabai not responding", action: nil, keyEquivalent: "")
            addQuit(menu); return
        }
        let byID = Dictionary(windows.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })
        var lastDisplay = 0
        for space in spaces {
            if space.display != lastDisplay {
                if lastDisplay != 0 { menu.addItem(.separator()) }
                let h = NSMenuItem(title: "Display \(space.display)", action: nil, keyEquivalent: "")
                h.isEnabled = false
                menu.addItem(h)
                lastDisplay = space.display
            }
            let icons: [NSImage] = space.windows.compactMap { id in
                guard let pid = byID[id]?.pid,
                      let icon = NSRunningApplication(processIdentifier: pid_t(pid))?.icon
                else { return nil }
                let copy = icon.copy() as! NSImage
                copy.size = NSSize(width: 18, height: 18)
                return copy
            }
            let item = NSMenuItem()
            item.view = SpaceRow(space, icons: icons) { [weak self] name in
                _ = yabai(["-m", "space", "--focus", name])
                self?.updateTitle()
            }
            menu.addItem(item)
        }
        addQuit(menu)
    }

    private func addQuit(_ menu: NSMenu) {
        menu.addItem(.separator())
        let restart = NSMenuItem(title: "Restart yabai",
            action: #selector(restartYabai), keyEquivalent: "r")
        restart.target = self
        restart.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil)
        menu.addItem(restart)
        let quit = NSMenuItem(title: "Quit",
            action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        quit.image = NSImage(systemSymbolName: "power", accessibilityDescription: nil)
        menu.addItem(quit)
    }

    @objc func restartYabai() {
        _ = yabai(["--restart-service"])
        // yabai takes ~1–2s to come back; refresh the label once it has.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in self?.updateTitle() }
    }
}

let app = NSApplication.shared
let controller = SpacesController()
app.delegate = controller
app.setActivationPolicy(.accessory)
app.run()
