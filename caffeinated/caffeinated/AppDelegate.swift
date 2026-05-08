import Cocoa
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let manager = CaffeinateManager()
    private var aboutWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
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
        button.title = manager.isActive ? "☕" : "🍵"
        button.toolTip = "Caffeinate-d: \(manager.isActive ? "ON" : "OFF")"
    }

    private func showMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(terminate), keyEquivalent: "q"))
        
        statusItem?.popUpMenu(menu)
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
