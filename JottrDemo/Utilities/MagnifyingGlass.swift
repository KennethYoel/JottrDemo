//
//  MagnifyingGlass.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/11/22.
//

import Foundation
import SwiftUI

struct MagnifyingGlass: View {
    @Binding var showSearchScreen: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(.white)
                .frame(width: 90, height: 45)
                .padding([.trailing], 25)
            Button {
                showSearchScreen.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.original)
                    .font(.title3)
                    .padding([.trailing], 25)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Show Search")
        }
    }
}

// a custom modifier
//struct MagnifyingGlass: ViewModifier {
//    @Binding var showingSearchScreen: Bool
    
    // Before iOS 15.2 .safeAreaInset worked only with ScrollView, but from 15.2 and later this also works with List and Form.
//    func body(content: Content) -> some View {
//        content
//            .safeAreaInset(edge: .bottom, alignment: .trailing) {
//                ZStack {
//                    Capsule()
//                        .fill(.white)
//                        .frame(width: 90, height: 45)
//                        .padding([.trailing], 25)
//                    Button {
//                        showingSearchScreen.toggle()
//                    } label: {
//                        Image(systemName: "magnifyingglass")
//                            .renderingMode(.original)
//                            .font(.headline)
//                            .padding([.trailing], 25)
//                    }
//                    .buttonStyle(.plain)
//                    .accessibilityLabel("Show Search")
//                }
//            }
//    }
//}

// extensions on View that make working with custom modifiers easier to use
//extension View {
//    func magnifyingGlass(show search: Binding<Bool>) -> some View {
//        modifier(MagnifyingGlass(showingSearchScreen: search))
//    }
//}
