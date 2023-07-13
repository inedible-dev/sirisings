//
//  LyricsBlock.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 16/4/23.
//

import Foundation

struct LyricsBlock: Codable, Identifiable {
    
    enum GettableBlockValue {
        case volume, pitch, rate, preDelay
    }
    
    var id = UUID().uuidString
    var lyric: String
    var volume: Float = 100
    var pitch: Float = 1
    var rate: Float = 0.5
    var preDelay: Float = 0
    
    var isFocused = false
    
    func getValue(_ variable: GettableBlockValue) -> Float {
        switch variable {
        case .volume:
            return volume
        case .pitch:
            return pitch
        case .rate:
            return rate
        case .preDelay:
            return preDelay
        }
    }
    
    mutating func assignValue(_ variable: GettableBlockValue, value: Float) {
        switch variable {
        case .volume:
            volume = value
        case .pitch:
            pitch = value
        case .rate:
            rate = value
        case .preDelay:
            preDelay = value
        }
    }
    
}
