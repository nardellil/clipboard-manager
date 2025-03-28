//
//  ClipItem.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//

import Foundation

struct ClipItem: Identifiable, Codable {
    let id: String
    var value: String
    let timestamp: Int
    var hits: Int
    
    init(id: String, value: String, hits: Int = 1) {
        self.id = id
        self.value = value
        self.timestamp = Int(Date().timeIntervalSince1970)
        self.hits = hits
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.value = try container.decode(String.self, forKey: .value)
        self.timestamp = try container.decodeIfPresent(Int.self, forKey: .timestamp) ?? 0
        self.hits = try container.decodeIfPresent(Int.self, forKey: .hits) ?? 1
    }
}
