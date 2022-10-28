//
//  KeyboardToolbar.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/13/22.
//

import Foundation
import SwiftUI

struct KeyboardToolbar: ToolbarContent {
    @Environment(\.undoManager) var undoManager
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            if let undoManager = undoManager {
                Button(action: undoManager.undo) {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                }
                .disabled(!undoManager.canUndo)

                Button(action: undoManager.redo) {
                    Label("Redo", systemImage: "arrow.uturn.forward")
                }
                .disabled(!undoManager.canRedo)
            }
            
            Spacer()
            
            Button {
//                hideKeyboardAndSave()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }
}
