//
//  HotkeySettingsHandler.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 30/03/25.
//

import SwiftUI
import AppKit

class HotkeySettingsHandler: NSObject, NSWindowDelegate {
    private var hotkeySettingsWindow: NSWindow?
    private weak var panel: NSPanel?

    init(panel: NSPanel) {
        self.panel = panel
    }

    func showHotkeySettings() {
        HotKeysService.deregister()
        panel?.alphaValue = 0

        if hotkeySettingsWindow == nil {
            hotkeySettingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 480),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            hotkeySettingsWindow?.title = "Choose Hotkey"
            hotkeySettingsWindow?.center()
            hotkeySettingsWindow?.isReleasedWhenClosed = false
            hotkeySettingsWindow?.isOpaque = false
            hotkeySettingsWindow?.delegate = self
        }

        let settingsView = HotkeySettingsView()
        hotkeySettingsWindow?.contentView = NSHostingView(rootView: settingsView)
        hotkeySettingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        hotkeySettingsWindow?.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            hotkeySettingsWindow?.animator().alphaValue = 1.0
        })
    }
    
    func windowShouldClose(_ window: NSWindow) -> Bool {
        guard window == hotkeySettingsWindow else { return true }

        HotKeysService.reregister()

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().alphaValue = 0
        }, completionHandler: {
            window.orderOut(nil)
        })

        return false
    }
    
    
}
