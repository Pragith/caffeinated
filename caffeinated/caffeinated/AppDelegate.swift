import Cocoa
import SwiftUI
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let manager = CaffeinateManager()
    private var aboutWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Commented out to ensure App Store sandboxing compliance. Will address later.
        // checkActualLidSleepStatus()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.target = self
            button.action = #selector(handleStatusItemClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            updateUI()
        }
        
        manager.onStateChange = { [weak self] in
            self?.updateUI()
        }
    }

    @objc private func handleStatusItemClick(_ sender: Any?) {
        let event = NSApp.currentEvent
        if event?.type == .rightMouseUp {
            showMenu()
        } else {
            manager.toggle()
        }
    }

    private func updateUI() {
        guard let button = statusItem?.button else { return }
        let symbolName = manager.isActive ? "cup.and.saucer.fill" : "cup.and.saucer"
        if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Caffeinate-d") {
            image.isTemplate = true
            button.image = image
        }
        button.title = ""
        button.toolTip = "Caffeinate-d: \(manager.isActive ? "ON" : "OFF")"
    }

    private func showMenu() {
        let menu = NSMenu()
        
        // --- Status ---
        let statusLabel = NSMenuItem(title: manager.isActive ? "Active (Indefinite)" : "Caffeinate-d is Off", action: nil, keyEquivalent: "")
        statusLabel.isEnabled = false
        menu.addItem(statusLabel)
        menu.addItem(NSMenuItem.separator())

        // --- Intervals ---
        let intervals = NSMenuItem(title: "Activate for...", action: nil, keyEquivalent: "")
        let subMenu = NSMenu()
        
        let durations: [(String, TimeInterval)] = [
            ("1 Minute", 60),
            ("2 Minutes", 120),
            ("5 Minutes", 300),
            ("10 Minutes", 600)
        ]
        
        for (label, time) in durations {
            let item = NSMenuItem(title: label, action: #selector(startWithDuration(_:)), keyEquivalent: "")
            item.representedObject = time
            subMenu.addItem(item)
        }
        intervals.submenu = subMenu
        menu.addItem(intervals)
        
        menu.addItem(NSMenuItem.separator())

        // --- Preferences ---
        let autostart = NSMenuItem(title: "Launch at Login", action: #selector(toggleAutostart(_:)), keyEquivalent: "")
        autostart.state = isLaunchAtLoginEnabled ? .on : .off
        menu.addItem(autostart)
        
        // Commented out to ensure App Store sandboxing compliance. Will address later.
        /*
        let lidSleep = NSMenuItem(title: "Prevent Lid Sleep (Requires Password)", action: #selector(toggleLidSleep(_:)), keyEquivalent: "")
        lidSleep.state = isLidSleepDisabled ? .on : .off
        menu.addItem(lidSleep)
        */
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Buy me a coffee...", action: #selector(buyMeACoffee), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(terminate), keyEquivalent: "q"))
        
        if let button = statusItem?.button {
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height), in: button)
        }
    }

    @objc private func startWithDuration(_ sender: NSMenuItem) {
        if let duration = sender.representedObject as? TimeInterval {
            manager.start(duration: duration)
        }
    }

    @objc private func toggleAutostart(_ sender: NSMenuItem) {
        let newState = !isLaunchAtLoginEnabled
        setLaunchAtLogin(enabled: newState)
        sender.state = newState ? .on : .off
    }

    private var isLaunchAtLoginEnabled: Bool {
        return SMAppService.mainApp.status == .enabled
    }

    private func setLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to update launch at login status: \(error)")
        }
    }

    @objc private func showAbout() {
        if aboutWindow == nil {
            let aboutView = AboutView()
            let hostingController = NSHostingController(rootView: aboutView)
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 250),
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false)
            window.center()
            window.title = "About Caffeinate-d"
            window.contentViewController = hostingController
            window.isReleasedWhenClosed = false
            aboutWindow = window
        }
        
        aboutWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func buyMeACoffee() {
        if let url = URL(string: "https://buymeacoffee.com/pragith") {
            NSWorkspace.shared.open(url)
        }
    }

    // The following features are commented out to ensure App Store sandboxing compliance.
    // Sandboxed applications are strictly forbidden from executing administrative shell scripts or calling pmset disablesleep.
    // We will address this later (e.g., via a separate, non-sandboxed companion/helper tool).
    /*
    private var isLidSleepDisabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isLidSleepDisabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLidSleepDisabled")
        }
    }

    private func checkActualLidSleepStatus() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        process.arguments = ["-g"]
        let pipe = Pipe()
        process.standardOutput = pipe
        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                let isDisabled = output.contains("disablesleep") && (output.contains("disablesleep\t1") || output.contains("disablesleep 1"))
                UserDefaults.standard.set(isDisabled, forKey: "isLidSleepDisabled")
            }
        } catch {
            print("Failed to read pmset status: \(error)")
        }
    }

    private func setLidSleepDisabled(_ disabled: Bool) -> Bool {
        let value = disabled ? 1 : 0
        let script = "do shell script \"pmset -a disablesleep \(value)\" with administrator privileges"
        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        let result = appleScript?.executeAndReturnError(&error)
        
        if let error = error {
            print("AppleScript error: \(error)")
            return false
        }
        return result != nil
    }

    @objc private func toggleLidSleep(_ sender: NSMenuItem) {
        let targetState = !isLidSleepDisabled
        if setLidSleepDisabled(targetState) {
            isLidSleepDisabled = targetState
            sender.state = targetState ? .on : .off
        } else {
            // User canceled or authentication failed, keep the old state
            sender.state = isLidSleepDisabled ? .on : .off
        }
    }
    */

    @objc private func terminate() {
        manager.stop()
        NSApp.terminate(nil)
    }
}
