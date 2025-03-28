//
//  DBService.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 10/04/2019.
//  Copyright © 2019 Luca Nardelli. All rights reserved.
//

import Foundation

final class DBService {
    
    static var items: [ClipItem] = []
    static var filteredItems: [ClipItem] = []
    static var filter: String = ""
    static let MAX_ENTRIES = 10000
    static let PREVIEW_SIZE = 256
    static var listener: () -> Void = {}
    
    static func filter(text: String = "") {
        self.filter = text.uppercased()
        filteredItems = items.filter({ item in return filter.count == 0 || item.value.uppercased().contains(filter) })
        listener()
    }
    
    static func getItemValue(_ row: Int) -> String {
        let item = filteredItems[row]
        if let value = getAttachment(item.id) {
            return value
        }
        return item.value
    }
    
    static func getItemValue(_ item: ClipItem) -> String {
        if let value = getAttachment(item.id) {
            return value
        }
        return item.value
    }
    
    static func addItem(_ item: String) {
        let preview = String(item.prefix(PREVIEW_SIZE))
        let id = NSUUID().uuidString;
        var newItem = ClipItem(id: id, value: preview)
        
        if let existing = items.firstIndex(where: { item in return item.value == preview}) {
            newItem.hits = items[existing].hits + 1
            deleteAttachment(items[existing].id)
            items.remove(at: existing)
        }
        if item.count > PREVIEW_SIZE {
            saveAttachment(id: id, item: item)
        }
        items.insert(newItem, at: 0)
        
        if items.count > MAX_ENTRIES {
            deleteAttachment(items[items.count - 1].id)
            items.remove(at: items.count - 1)
        }
        filter()
        
        save()
    }
    
    static func deleteItem(_ index:Int) {
        deleteAttachment(items[index].id)
        items.remove(at: index)
        filter()
        save()
    }
    
    static func deleteAttachment(_ id: String) {
        guard let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileUrl = docFolder.appendingPathComponent("clips").appendingPathComponent(id)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                try FileManager.default.removeItem(at: fileUrl)
            } catch {
                print(error)
            }
        }
    }
    
    static func getAttachment(_ id: String) -> String? {
        guard let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let fileUrl = docFolder.appendingPathComponent("clips").appendingPathComponent(id)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                return try String(contentsOf: fileUrl, encoding: .utf8)
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    static func saveAttachment(id: String, item: String) {
        guard let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        var fileUrl = docFolder.appendingPathComponent("clips")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                try FileManager.default.createDirectory(at: fileUrl, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error)
            }
        }
        fileUrl = fileUrl.appendingPathComponent(id)
        do {
            try item.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    static func initialize() {
        guard let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileUrl = docFolder.appendingPathComponent("cmdb.json")
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                let data = try Data(contentsOf: fileUrl);
                let decoder = JSONDecoder()
                items = try decoder.decode([ClipItem].self, from: data)
                filter()
            } catch {
                print(error)
            }
        }
    }
    
    static func save() {
        guard let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileUrl = docFolder.appendingPathComponent("cmdb.json")
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(items)
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }

}
