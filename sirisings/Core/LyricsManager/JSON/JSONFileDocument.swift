//
//  JSONFileDocument.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 12/4/23.
//

import UniformTypeIdentifiers
import SwiftUI

struct JSONDocument: FileDocument {
    static let readableContentTypes: [UTType] = [.json]
    
    let data: Data
    
    private var jsonFileName = "Exported Song"
    
    init(_ value: some Codable, fileName: String, encoder: JSONEncoder = JSONEncoder()) throws {
        data = try encoder.encode(value)
        jsonFileName = fileName
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let wrapper = FileWrapper(regularFileWithContents: data)
        wrapper.preferredFilename = jsonFileName
        return wrapper
    }
}
