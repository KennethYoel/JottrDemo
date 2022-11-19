//
//  PlainTextFile.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/19/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct PlainTextFile: FileDocument {
    // tell the system we support only pdf
    static var readableContentTypes = [UTType.plainText] 
    
    // by default our document is empty
    var text = ""
    
    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
       text = initialText
    }
    
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

struct PDFFile: FileDocument {
    // tell the system we support only pdf
    static var readableContentTypes = [UTType.pdf]
    
    // by default our document is empty
    var pdf = ""
    
    // a simple initializer that creates new, empty documents
    init(initialPDF: String = "") {
       pdf = initialPDF
    }
    
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            pdf = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(pdf.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
