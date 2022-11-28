//
//  ViewModel-Extensions.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/9/22.
//

import Foundation
import SwiftUI

// MARK: Layout Extension

// custom view extension, for reusing a text layout-bundle together for one use case
extension Text {
    func activeItemStyle() -> some View {
        self.font(.system(size: 15, weight: .semibold, design: .serif))
    }
    
    func captionStyle() -> some View {
        self.font(.system(.caption, design: .serif))
    }
    
    func listRowStyle() -> some View {
        self
            .foregroundColor(.secondary)
            .font(.system(.subheadline, design: .serif))
            // limit the amount of text shown in each item in the list
            .lineLimit(3)
    }
    
    func subSecondaryStyle() -> some View {
        self
            .font(.system(.subheadline, design: .serif))
            .foregroundColor(.secondary)
            .fontWeight(.black)
            .textCase(.uppercase)
            .iOS { $0.padding(10) }
    }
}

// custom view extension, for reusing a label layout-bundle together for one use case
extension Label {
    func captionStyle() -> some View {
        self.font(.system(.caption, design: .serif))
    }
    
    func subHeaderStyle() -> some View {
        self.font(.system(.subheadline, design: .serif))
    }
}

// custom view extension, for reusing a button layout-bundle together for one use case
extension Button {
    func primaryStyle() -> some View {
        self
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

// MARK: Modifiers Extension
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

// MARK: Conversion Extension

// convert AttributedString to String
extension AttributedString {
    var convertToString: String {
        get {
            let attributedSample = NSMutableAttributedString(self)
            return attributedSample.string
        }
    }
}

// MARK: View Extension

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
}
