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
                .frame(width: 50, height: 50)
                .padding([.trailing], 30)
            Button(action: { showSearchScreen.toggle() }, label: {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.original)
                    .font(.title3)
                    .padding([.trailing], 30)
            })
                .buttonStyle(.plain)
                .accessibilityLabel("Show Search")
        }
    }
}
