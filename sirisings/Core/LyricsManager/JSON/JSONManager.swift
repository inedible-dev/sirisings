//
//  JSONManager.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import Foundation

class JSONManager {
    func encodeJSON(_ data: [LyricsBlock]) -> Data? {
        if let encoded = try? JSONEncoder().encode(data) {
            return encoded
        }
        else {
            return nil
        }
    }
    
    func decodeJSON(jsonData: Data) -> [LyricsBlock]? {
        if let decoded = try? JSONDecoder().decode([LyricsBlock].self, from: jsonData) {
            return decoded
        } else { return nil }
    }
}
