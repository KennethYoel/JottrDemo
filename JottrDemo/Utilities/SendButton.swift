//
//  SendButton.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

struct SendButtonStyle: ButtonStyle {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    func makeBody(configuration: Configuration) -> some View {
        // label is the view that describes the content of the button
        configuration.label
            .frame(maxWidth: horizontalSizeClass == .compact ?
                .infinity : 280)
            .foregroundColor(.white)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .opacity(configuration.isPressed ? 0.8 : 1)
                    .scaleEffect(configuration.isPressed ? 0.98 : 1)
                    .animation(.easeInOut, value: configuration.isPressed)
            }
    }
}
