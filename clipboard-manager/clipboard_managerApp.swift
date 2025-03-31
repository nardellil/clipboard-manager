//
//  clipboard_managerApp.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//

import SwiftUI

@main
struct clipboard_managerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {}
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: NSPanel!
    var hostingController: NSHostingController<ContentView>!
    var statusItem: NSStatusItem!
    var hotkeyHandler: HotkeySettingsHandler!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
        hostingController = NSHostingController(rootView: contentView)

        panel = ClipWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 400),
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.backgroundColor = .clear
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.contentView = hostingController.view

        setupStatusBarItem()
        hotkeyHandler = HotkeySettingsHandler(panel: panel)
        HotKeysService.register() { self.show() }
        DBService.initialize()
        ClipboardService.watch()
    }

    @objc func show() {
        for screen in NSScreen.screens {
           let mouseX = NSEvent.mouseLocation.x;
           let mouseY = NSEvent.mouseLocation.y;
           if screen.frame.minX < mouseX && screen.frame.maxX > mouseX
               && screen.frame.minY < mouseY && screen.frame.maxY > mouseY {
               let centerX = screen.frame.minX + (screen.frame.maxX - screen.frame.minX) / 2 - 150
               let centerY = screen.frame.minY + (screen.frame.maxY - screen.frame.minY) / 2 + 200
               panel.setFrameTopLeftPoint(NSPoint(x: centerX, y: centerY))
           }
        }
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        panel.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            panel.animator().alphaValue = 1.0
        })
    }

    @objc func showHotkeySettings() {
        hotkeyHandler.showHotkeySettings()
    }

    func setupStatusBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "clipboard.fill", accessibilityDescription: nil)
        }
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Show", action: #selector(show), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Choose Hotkey", action: #selector(showHotkeySettings), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }
}
