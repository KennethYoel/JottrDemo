//
//  EditorToolbar.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/3/22.
//

import Foundation
import SwiftUI

struct EditorToolbar: ToolbarContent {
    // MARK: Properties
    
    // retrieve the txtcompl view model from the environment
    @ObservedObject var txtComplVM: TxtComplViewModel = .standard
    // binded values
    @Binding var presentExportView: Bool
    @Binding var presentShareView: Bool
    @Binding var showPromptEditor: Bool
    @FocusState var keyboardActive: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                // present the ExportView
                Button(action: { showPromptEditor.toggle() }, label: { Label("Export", systemImage: "arrow.up.doc") })
                // present the UIShareView
                Button(action: { presentShareView.toggle() }, label: { Label("Share", systemImage: "square.and.arrow.up") })
                // routes user to the PromptEditorView
                Button(action: { showPromptEditor.toggle() }, label: {
                    Label("Prompt Editor", systemImage: "chevron.left.forwardslash.chevron.right")
                })
            } label: {
                 Image(systemName: "ellipsis.circle")
            }
            .foregroundColor(.black)
        }
    }
}

/*
 EditorToolbar(presentExportView: $isShowingPromptEditorScreen, presentShareView: $isShareViewPresented, showPromptEditor: $isShowingPromptEditorScreen, keyboardActive: _isInputActive)
 */
