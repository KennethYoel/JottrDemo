//
//  WritingPadView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation
import SwiftUI

struct TextInputView: View {
    @Binding var isLoading: Bool
    @Binding var pen: String
    
    @ViewBuilder private var loadingOverlay: some View {
        if isLoading {
            Color(white: 0, opacity: 0.05)
            GIFView().frame(width: 295, height: 155)
        }
    }
    
    var body: some View {
        TextEditorView(text: $pen)
            .padding([.leading, .top, .trailing,])
            .overlay(loadingOverlay)
    }
}

struct WritingPadView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(isLoading: .constant(true), pen: .constant("This is a test."))
    }
}
