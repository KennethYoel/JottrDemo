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
    @Binding var showNewPage: Bool
    @Binding var presentExportView: Bool
    @Binding var presentShareView: Bool
    @Binding var showPromptEditor: Bool
    @Binding var sendingContent: Bool
    @FocusState var keyboardActive: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            // present a new page for content writing
            Button(action: { showNewPage.toggle() }, label: { Label("New Story", systemImage: "square.and.pencil") })
            
            Menu {
                // present the ExportView
                Button(action: { presentExportView.toggle() }, label: { Label("Export", systemImage: "arrow.up.doc") })
                // present the UIShareView
                Button(action: { presentShareView.toggle() }, label: { Label("Share", systemImage: "square.and.arrow.up") })
                
                Divider()
                
                // routes user to the PromptEditorView
                Button(action: { showPromptEditor.toggle() }, label: {
                    Label("Prompt Editor", systemImage: "chevron.left.forwardslash.chevron.right")
                })
            } label: {
                 Image(systemName: "ellipsis.circle")
            }
            .foregroundColor(.black)
            
            // show submit button if keyboard is active
            if keyboardActive {
                Button(action: { sendingContent.toggle() }, label: { Image(systemName: "arrow.up") })
                    .padding([.leading, .trailing])
                    .buttonStyle(.plain)
            }
        }
    }
}
