//
//  HotkeyConfigurationService.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 30/03/25.
//
import Carbon

struct HotKeyConfiguration: Codable {
    var keyCode: UInt32
    var modifiers: UInt32
    
    static var `default`: HotKeyConfiguration {
        return HotKeyConfiguration(keyCode: 41, modifiers: UInt32(cmdKey)) // Default is Command + J (key code 41)
    }
    
    var isValid: Bool {
        // To be valid, a hotkey must have at least one modifier
        return modifiers != 0
    }
    
    var description: String {
        var description = ""
        
        if modifiers & UInt32(cmdKey) != 0 {
            description += "⌘ "
        }
        if modifiers & UInt32(optionKey) != 0 {
            description += "⌥ "
        }
        if modifiers & UInt32(controlKey) != 0 {
            description += "⌃ "
        }
        if modifiers & UInt32(shiftKey) != 0 {
            description += "⇧ "
        }
        
        // Map key code to corresponding character
        let keyChar = keyCodeToString(keyCode: keyCode)
        description += keyChar
        
        return description
    }
    
    private func keyCodeToString(keyCode: UInt32) -> String {
        // Use the system APIs to get the correct key based on the current keyboard layout
        var currentKeyboard: TISInputSource?
        
        // Get the current keyboard layout
        if let currentKeyboardRef = TISCopyCurrentKeyboardLayoutInputSource()?.takeRetainedValue() {
            currentKeyboard = currentKeyboardRef
        } else {
            // Fallback to default English mapping if we can't get current keyboard
            return fallbackKeyCodeToString(keyCode: keyCode)
        }
        
        // Get the layout data
        guard let layoutData = TISGetInputSourceProperty(currentKeyboard!, kTISPropertyUnicodeKeyLayoutData) else {
            return fallbackKeyCodeToString(keyCode: keyCode)
        }
        
        // Convert to the actual keyboard layout data
        let keyboardLayout = unsafeBitCast(layoutData, to: CFData.self) as Data
        
        // Create a buffer for the translated characters
        var chars = [UniChar](repeating: 0, count: 4)
        var length: UInt32 = 0
        var actualLength: Int = 0
        
        // Try to translate the key code to characters based on the current layout
        let result = keyboardLayout.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) -> Bool in
            if let uchrData = bufferPointer.baseAddress?.assumingMemoryBound(to: UCKeyboardLayout.self) {
                let error = UCKeyTranslate(
                    uchrData,
                    UInt16(keyCode),
                    UInt16(kUCKeyActionDisplay),
                    0, // No modifiers for display
                    UInt32(LMGetKbdType()),
                    UInt32(kUCKeyTranslateNoDeadKeysBit),
                    &length,
                    4,
                    &actualLength,
                    &chars
                )
                return error == noErr
            }
            return false
        }
        
        if result && actualLength > 0 {
            return String(utf16CodeUnits: chars, count: Int(actualLength))
        }
        
        // Fall back to the hardcoded map if the system API fails
        return fallbackKeyCodeToString(keyCode: keyCode)
    }
    
    private func fallbackKeyCodeToString(keyCode: UInt32) -> String {
        // Common mapping for some key codes as fallback
        let keyCodeMap: [UInt32: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
            8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
            16: "Y", 17: "T", 18: "1", 19: "2", 20: "3", 21: "4", 22: "6",
            23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8", 29: "0",
            30: "]", 31: "O", 32: "U", 33: "[", 34: "I", 35: "P", 36: "Return",
            37: "L", 38: "J", 39: "'", 40: "K", 41: ";", 42: "\\", 43: ",",
            44: "/", 45: "N", 46: "M", 47: ".", 48: "Tab", 49: "Space",
            50: "`", 51: "Delete", 53: "Escape", 65: ".", 67: "*",
            69: "+", 71: "Clear", 75: "/", 76: "Enter", 78: "-",
            81: "=", 82: "0", 83: "1", 84: "2", 85: "3", 86: "4",
            87: "5", 88: "6", 89: "7", 91: "8", 92: "9",
            123: "←", 124: "→", 125: "↓", 126: "↑"
        ]
        
        return keyCodeMap[keyCode] ?? "Key \(keyCode)"
    }
}
