import AppKit

// A tiny menu-bar agent for yabai:
//   • the status item shows the name of the Desktop you're currently on
//   • clicking it opens a dropdown of every Desktop, grouped by display, with
//     each window (app icon + title) as a submenu — click a Desktop or a window
//     to focus it.
// All data comes from `yabai -m query`; nothing private is used.

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
}

final class SpacesController: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .bold)

        let menu = NSMenu()
        menu.delegate = self            // rebuilt fresh every time it opens
        statusItem.menu = menu

        updateTitle()

        // Public notification: fires whenever the active Space changes.
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(updateTitle),
            name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)

        // Light fallback poll so a label edit / app move shows up too.
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateTitle()
        }
    }

    // Menu-bar label = the focused Desktop's name.
    @objc func updateTitle() {
        guard let space = decode(Space.self, yabai(["-m", "query", "--spaces", "--space"])) else {
            statusItem.button?.title = "—"
            return
        }
        statusItem.button?.title = space.name
    }

    // Rebuild the dropdown each time it opens so it's always current.
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        guard let spaces = decode([Space].self, yabai(["-m", "query", "--spaces"])),
              let windows = decode([Window].self, yabai(["-m", "query", "--windows"])) else {
            menu.addItem(withTitle: "yabai not responding", action: nil, keyEquivalent: "")
            addFooter(to: menu)
            return
        }
        let windowByID = Dictionary(windows.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })

        var lastDisplay = 0
        for space in spaces {
            if space.display != lastDisplay {
                if lastDisplay != 0 { menu.addItem(.separator()) }
                let header = NSMenuItem(title: "Display \(space.display)", action: nil, keyEquivalent: "")
                header.isEnabled = false
                menu.addItem(header)
                lastDisplay = space.display
            }

            let apps = space.windows.compactMap { windowByID[$0]?.app }
            let suffix = apps.isEmpty ? "" : "   " + apps.joined(separator: ", ")
            let item = NSMenuItem(title: "\(space.index)  \(space.name)\(suffix)",
                                  action: #selector(focusSpace(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = space.name
            item.state = space.hasFocus ? .on : .off

            if !space.windows.isEmpty {
                let sub = NSMenu()
                for wid in space.windows {
                    guard let w = windowByID[wid] else { continue }
                    let title = w.title.isEmpty ? w.app : "\(w.app) — \(w.title)"
                    let wItem = NSMenuItem(title: title, action: #selector(focusWindow(_:)), keyEquivalent: "")
                    wItem.target = self
                    wItem.representedObject = w.id
                    if let running = NSRunningApplication(processIdentifier: pid_t(w.pid)),
                       let icon = running.icon {
                        icon.size = NSSize(width: 16, height: 16)
                        wItem.image = icon
                    }
                    sub.addItem(wItem)
                }
                item.submenu = sub
            }
            menu.addItem(item)
        }
        addFooter(to: menu)
    }

    private func addFooter(to menu: NSMenu) {
        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quit)
    }

    @objc func focusSpace(_ sender: NSMenuItem) {
        guard let name = sender.representedObject as? String else { return }
        _ = yabai(["-m", "space", "--focus", name])
        updateTitle()
    }

    @objc func focusWindow(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? Int else { return }
        _ = yabai(["-m", "window", "--focus", "\(id)"])
        updateTitle()
    }
}

let app = NSApplication.shared
let controller = SpacesController()
app.delegate = controller
app.setActivationPolicy(.accessory)   // menu-bar agent: no Dock icon
app.run()
