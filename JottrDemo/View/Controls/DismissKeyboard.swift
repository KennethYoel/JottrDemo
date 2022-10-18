//
//  DismissKeyboard.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/16/22.
//

import Foundation
import SwiftUI

// a custom modifier
struct DismissKeyBoard: ViewModifier {
    @Binding var isKeyboardActive: Bool
    @Environment(\.dismiss) var dismissIt
    
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                if isKeyboardActive {
                    ZStack {
                        Capsule()
                            .fill(.white)
                            .frame(width: 45, height: 45)
                            .padding([.trailing], 25)
                        Button {
                            dismissIt()
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .renderingMode(.original)
                                .font(.headline)
                                .padding([.trailing], 25)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Dismiss Keyboard")
                    }
                }
            }
    }
}

// extensions on View that make working with custom modifiers easier to use
extension View {
    func dismissKeyBoard(show keyboardDismiss: Binding<Bool>) -> some View {
        modifier(DismissKeyBoard(isKeyboardActive: keyboardDismiss))
    }
}
