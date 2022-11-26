//
//  DoneButton.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/26/22.
//

import Foundation
import SwiftUI

struct DoneButton: ToolbarContent {
    // MARK: Properties
    
    @Binding var isDismiss: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done", action: { isDismiss.toggle() })
                .buttonStyle(.plain)
                .padding()
        }
    }
}
