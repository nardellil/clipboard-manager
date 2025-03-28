//
//  ClipWindow.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//
import Foundation
import Cocoa

final class ClipWindow: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }
    
    override func resignKey() {
        super.resignKey()
        NSApplication.shared.hide(nil)

    }
    
}
