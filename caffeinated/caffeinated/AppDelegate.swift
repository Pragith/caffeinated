import Cocoa
import SwiftUI
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let manager = CaffeinateManager()
    private var aboutWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
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
        button.image = NSImage(named: manager.isActive ? "TrayIconOn" : "TrayIconOff")
        button.toolTip = "Caffeinate-d: \(manager.isActive ? "ON" : "OFF")"
    }

    private func showMenu() {
        let menu = NSMenu()
        
        // --- Status ---
        let statusItem = NSMenuItem(title: manager.isActive ? "Active (Indefinite)" : "Caffeinate-d is Off", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)
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
        
        menu.addItem(NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(terminate), keyEquivalent: "q"))
        
        statusItem?.popUpMenu(menu)
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

    @objc private func terminate() {
        manager.stop()
        NSApp.terminate(nil)
    }
}
