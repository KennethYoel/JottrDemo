//
//  HideSectionView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import SwiftUI

struct HideSectionView: View {
    // MARK: Properties
    
    @Binding var isHidden: Bool
    
    var body: some View {
        Menu("...") {
            if !isHidden {
                Button(action: collapse, label: { Label("Collapse", systemImage: "rectangle.compress.vertical") })
            } else {
                Button(action: expand, label: { Label("Expand", systemImage: "rectangle.expand.vertical") })
            }
        }
        .font(.system(.caption, design: .serif))
    }
    
    private func collapse() {
        isHidden.toggle()
    }

    private func expand() {
        isHidden.toggle()
    }
}

