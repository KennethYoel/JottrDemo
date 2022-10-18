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
    
    @Binding var title: String
    @Binding var text: String
    let placeholder: String
        
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .font(.custom("Futura", size: 17))
                .padding(.leading, 5)
            ZStack(alignment: .leading) {
                if text.isEmpty {
                   VStack {
                        Text(placeholder)
                           .font(.custom("Futura", size: 17))
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
                        .font(.custom("Futura", size: 17))
                    
                    Spacer()
                }
            }
        }
    }
}
