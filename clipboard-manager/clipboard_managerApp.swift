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
        HotKeysService.register() { self.show() }
        DBService.initialize()
        ClipboardService.watch()
    }

    @objc func show() {
        if let screen = NSScreen.main {
            let screenFrame = screen.frame
            let panelSize = panel.frame.size
            let origin = NSPoint(
                x: (screenFrame.width - panelSize.width) / 2,
                y: (screenFrame.height - panelSize.height) / 2
            )
            panel.setFrameOrigin(origin)
        }
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        panel.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ context in
           context.duration = 0.25
           panel.animator().alphaValue = 1.0
       })
    }

    // System Tray Icon
    var statusItem: NSStatusItem!

    func setupStatusBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "clipboard.fill", accessibilityDescription: nil)
        }
        let menu = NSMenu()
                
        menu.addItem(NSMenuItem(title: "Show", action: #selector(show), keyEquivalent: "s"))
        //menu.addItem(NSMenuItem(title: "Run at startup", action: #selector(toggleRunAtStartup(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
   
}
