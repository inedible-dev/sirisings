//
//  LyricsManager.swift
//
//  Created by Wongkraiwich Chuenchomphu on 30/3/23.
//

import Foundation
import SwiftUI

let userDefaults = UserDefaults.standard

class LyricsManager: ObservableObject {
    
    static let defaultBlock = [LyricsBlock(lyric: "No lyrics available")]
    
    @Published var selectedID: String? {
        didSet { userDefaults.set(selectedID, forKey: "selectedID") }
    }
    @Published var data: [LyricsBlock] {
        didSet { userDefaults.set(json.encodeJSON(data), forKey: "lyricsTempData") }
    }
    @Published var lastLyric = ""
    
    let json = JSONManager()
    
    init() {
        data = LyricsManager.defaultBlock
        selectedID = data.first?.id
    }
    
    /// User Defaults
    
    func getLastSessionLyrics() -> Data? {
        return userDefaults.data(forKey: "lyricsTempData")
    }
    
    func getLastSessionSelectedID() -> String? {
        let lastSelectedID =  userDefaults.string(forKey: "selectedID")
        if (data.first(where: { $0.id == lastSelectedID }) != nil) {
            return lastSelectedID
        } else {
            return nil
        }
    }
    
    func checkLastSession() -> Bool {
        if (getLastSessionLyrics() != nil) && (getLastSessionSelectedID() != nil) {
            return true
        } else {
            return false
        }
    }
    
    func deleteLastSession() {
        data = LyricsManager.defaultBlock
        assignFirstSelectedID()
        if checkLastSession() {
            userDefaults.removeObject(forKey: "lyricsTempData")
            userDefaults.removeObject(forKey: "selectedID")
        }
    }
    
    /// Selected ID
    
    func assignFirstSelectedID() {
        selectedID = data.first?.id
    }
    
    func checkSelectedIDExists() -> Bool {
        if data.contains(where: { $0.id == selectedID}) {
            return true
        } else { return false }
    }
    
    func getDataFromSelectedID() -> LyricsBlock? {
        if selectedID != nil {
            return data.first(where: { $0.id == selectedID })!
        } else {
            return nil
        }
    }
    
    func getIndexFromSelectedID() -> Int? {
        if selectedID != nil {
            return data.firstIndex(where: { $0.id == selectedID })
        } else {
            return nil
        }
    }
    
    func pushSelectedID() -> Bool {
        let idx = getIndexFromSelectedID()
        if idx != nil {
            let nextId = idx! + 1
            if data.indices.contains(nextId) {
                selectedID = data[nextId].id
                return true
            }
        }
        return false
    }
    
    /// String  ->  [LyricsBlock]
    
    func convertToLyricsBlock(lyrics: String) {
        let lyricsArray = lyrics.split(whereSeparator: \.isNewline)
        
        data = []
        
        for lyric in lyricsArray {
            data.append(LyricsBlock(lyric: String(lyric)))
        }
        assignFirstSelectedID()
        userDefaults.set(selectedID, forKey: "selectedID")
    }
    
    func previewLyricsBlock(lyrics: String) -> [LyricsBlock] {
        let lyricsArray = lyrics.split(whereSeparator: \.isNewline)
        
        return lyricsArray.map({ lyric in
            LyricsBlock(lyric: String(lyric))
        })
    }
    
    /// LyricsBlock management
    
    enum AddLyricBlock {
        case before, after
    }
    
    func addLyricBlock(_ insertPos: AddLyricBlock) {
        if var index = getIndexFromSelectedID() {
            if insertPos == .after {
                index += 1
            }
            
            let block = LyricsBlock(lyric: "", isFocused: true)
            let blockId = block.id
            
            data.insert(block, at: index)
            selectedID = blockId
        }
    }
    
    func deleteLyricBlock(id: String) {
        if data.count > 1 {
            data = data.filter { $0.id != id }
        } else {
            data = LyricsManager.defaultBlock
        }
        assignFirstSelectedID()
    }
    
    func getBinding(_ value: LyricsBlock.GettableBlockValue) -> Binding<Float> {
        return Binding (
            get: {
                Float(self.getDataFromSelectedID()!.getValue(value))
            },
            set: {
                if let index = self.getIndexFromSelectedID() {
                    let toTwoDecimals = Float(String(format:"%.2f", $0))
                    if toTwoDecimals != nil {
                        self.data[index].assignValue(value, value: toTwoDecimals!)
                    }
                }
            }
        )
    }
}
