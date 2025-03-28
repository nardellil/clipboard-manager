//
//  ClipboardWatcher.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 10/04/2019.
//  Copyright © 2019 Luca Nardelli. All rights reserved.
//

import Foundation
import AppKit

final class ClipboardService {
    
    static func watch() {
        let pasteboard = NSPasteboard.general;
        var lastChangeCount = pasteboard.changeCount;
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            let actualChangeCount = pasteboard.changeCount
            if actualChangeCount != lastChangeCount {
                lastChangeCount = actualChangeCount
                if let value = pasteboard.string(forType: .string) {
                    DBService.addItem(value)
                }
            }
        })
    }
    
    static func pasteItem(_ value: String) {
        /*guard isAccessibilityEnabled(isPrompt: false) else {
            showAccessibilityAuthenticationAlert()
            return
        }*/
        let pasteboard = NSPasteboard.general;
        pasteboard.clearContents()
        pasteboard.setString(value, forType: .string)
        NSApplication.shared.hide(nil)
          
        let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: true); // cmd-v down
        event1?.flags = CGEventFlags.maskCommand;
        event1?.post(tap: CGEventTapLocation.cghidEventTap);
        
        let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: false) // cmd-v up
        event2?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    static func isAccessibilityEnabled(isPrompt: Bool) -> Bool {
        let checkOptionPromptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let opts = [checkOptionPromptKey: isPrompt] as CFDictionary
        return AXIsProcessTrustedWithOptions(opts)
    }

    static func showAccessibilityAuthenticationAlert() {
        let alert = NSAlert()
        alert.messageText = "Accesibility is required to paste"
        alert.informativeText = "Accesibility is required to paste"
        alert.addButton(withTitle: "Allow")
        NSApp.activate(ignoringOtherApps: true)

        if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn {
            guard !openAccessibilitySettingWindow() else { return }
        }
        func openAccessibilitySettingWindow() -> Bool {
           guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else { return false }
           return NSWorkspace.shared.open(url)
       }
    }
}
