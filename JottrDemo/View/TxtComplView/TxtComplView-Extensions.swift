//
//  View-Extensions.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/9/22.
//

import Foundation
import SwiftUI

/*
 A custom extension to Binding so that I attach observing code directly to the binding rather than to the view – it lets me
 place the observer next to the thing it’s observing, rather than having lots of onChange() modifiers attached elsewhere in
 my view. by https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
 */
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
    /*
     Example of usage—
     @State private var rating = 0.0
     
     Slider(value: $rating.onChange(sliderChanged))
     
     func sliderChanged(_ value: Double) {
        Do something with value
     }
     */
}

// custom view extension, for reusing a text layout-bundle together for one use case
extension Text {
    func headerStyle() -> some View {
        self
            .font(.title2)
            .foregroundColor(.secondary)
            .fontWeight(.black)
            .textCase(.uppercase)
//            .iOS { $0.padding(10) }
    }
}

// custom view extension, for reusing a button layout-bundle together for one use case .primaryStyle()
extension Button {
    func primaryStyle() -> some View {
        self
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

extension View {
    // platform customization-different layouts for a chosen os
    func iOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(iOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    func macOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(macOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    func tvOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(tvOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    func watchOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(watchOS)
        return modifier(self)
        #else
        return self
        #endif
    }
}
