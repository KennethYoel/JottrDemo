//
//  AnimatedButton.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/13/22.
//

import Foundation
import SwiftUI

struct AnimatedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .serif))
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
