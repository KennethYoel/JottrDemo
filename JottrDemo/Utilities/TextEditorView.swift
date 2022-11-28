//
//  TextEditorView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

/*
 Code sample for a custom TextEditor with Placeholder functionality from cs4alhaider at
 https://stackoverflow.com/questions/62741851/how-to-add-placeholder-text-to-texteditor-in-swiftui
 */
struct TextEditorView: View {
    // MARK: Properties
    
    @Binding var text: String
    var placeholder: String = """
    Write The Title Here
    
    Perhap's we can begin with once upon a time...
    """
        
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
               VStack {
                    Text(placeholder)
                       .font(.system(.body, design: .serif))
                       .padding(.top, 10)
                       .padding(.leading, 5)
                       .opacity(0.7)
                   
                    Spacer()
                }
            }
            
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 150, maxHeight: .infinity)
                    .opacity(text.isEmpty ? 0.85 : 1)
                    .font(.system(.body, design: .serif))
                
                Spacer()
            }
        }
    }
}
