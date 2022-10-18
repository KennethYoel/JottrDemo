//
//  EditorToolbar.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

struct EditorToolbar: ToolbarContent {
    
//    @Binding var newStoryEditorScreen: Bool
    @Binding var showingShareView: Bool
    @Binding var showingPromptEditorScreen: Bool
    @FocusState var showingKeyboard: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if !showingKeyboard {
                Button {
                    showingPromptEditorScreen.toggle()
                } label: {
                    Label("Prompt Editor", systemImage: "chevron.left.forwardslash.chevron.right")
                }
                
                Menu {
                    Button {
                        showingPromptEditorScreen.toggle()
                    } label: {
                        Label("Export", systemImage: "arrow.up.doc")
                    }
                    
                    Button {
                        showingShareView.toggle()
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } label: {
                     Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

// EditorToolbar(showingShareView: $isShareViewPresented, showingPromptEditorScreen: $isShowingPromptEditorScreen, showingKeyboard: _isInputActive)
