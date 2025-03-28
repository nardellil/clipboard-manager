//
//  HotKey.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 09/04/2019.
//  Copyright © 2019 Luca Nardelli. All rights reserved.
//

import Carbon

final class HotKeysService {
    
    static var hotKeyRef: EventHotKeyRef?
    private static var hotkeyHandler: () -> Void = {};
    
    private static func eventHandler() {
        hotkeyHandler()
    }
    
    static func register(_ handler: @escaping  () -> Void) {
        hotkeyHandler = handler
        
        let hotkeyId = EventHotKeyID(signature: 1, id: 1)
        
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        InstallEventHandler(GetApplicationEventTarget(), {(nextHanlder, theEvent, userData) -> OSStatus in
            HotKeysService.eventHandler()
            return 1
        }, 1, &eventType, nil, nil)

        RegisterEventHotKey(UInt32(41), UInt32(cmdKey), hotkeyId, GetApplicationEventTarget(), 0, &self.hotKeyRef)
    }
    
    static func deregister() {
        UnregisterEventHotKey(self.hotKeyRef)
    }
}
