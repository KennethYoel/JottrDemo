//
//  DismissKeyboard.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/16/22.
//

import Foundation
import MessageUI
import SwiftUI

// a custom modifier
struct EmailResultAlert: ViewModifier {
    @State private var isShowingEmailResultAlert: Bool = true
    @Binding var emailResult: Result<MFMailComposeResult, Error>?
    
    func body(content: Content) -> some View {
        if emailResult != nil {
            content
                .alert(isPresented: $isShowingEmailResultAlert) {
                    Alert(title: Text(""),
                          message: Text(String(describing: emailResult)),
                          dismissButton: .default(Text("OK")))
                }
        }
    }
}

// extensions on View that make working with custom modifiers easier to use
extension View {
    func showEmailResult(show emailAlert: Binding<Result<MFMailComposeResult, Error>?>) -> some View {
        modifier(EmailResultAlert(emailResult: emailAlert))
    }
}
