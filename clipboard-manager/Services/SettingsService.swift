//
//  SettingsService.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//

import Foundation

final class SettingsService {
    static let shared = SettingsService()
    
    private let defaults = UserDefaults.standard
    private let hotKeyKey = "hotKeyConfiguration"
    
    private init() {}
    
    var hotKeyConfiguration: HotKeyConfiguration {
        get {
            if let data = defaults.data(forKey: hotKeyKey),
               let config = try? JSONDecoder().decode(HotKeyConfiguration.self, from: data) {
                return config
            }
            return HotKeyConfiguration.default
        }
        set {
            // Verify that the configuration is valid before saving it
            if newValue.isValid {
                if let data = try? JSONEncoder().encode(newValue) {
                    defaults.set(data, forKey: hotKeyKey)
                }
            }
        }
    }
    
    func resetHotKeyToDefault() {
        hotKeyConfiguration = HotKeyConfiguration.default
    }
} 
