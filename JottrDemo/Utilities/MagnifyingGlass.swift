//
//  MagnifyingGlass.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/11/22.
//

import Foundation
import SwiftUI

// launches the search view
struct MagnifyingGlass: View {
    @Binding var showSearchScreen: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 45, height: 45)
                .padding([.trailing], 25)
            Button(action: { showSearchScreen.toggle() }, label: {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.original)
                    .font(.title3)
                    .padding([.trailing], 25)
            })
                .buttonStyle(.plain)
                .accessibilityLabel("Show Search")
        }
    }
}
