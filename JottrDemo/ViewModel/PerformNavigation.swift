//
//  ActivateNavigation.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/31/22.
//

import Foundation

class PerformNavigation: ObservableObject {
    @Published var storyList: Story!
    @Published var showListingView: Bool = false
    @Published var showListingRow: Bool = false
    // add isActive for StoryListView and the StoryListDetail
    
    // used as @ObservedObject var <nameOfVariable>: PerformNavigation = .standard, so the class is initialzed from within the class itself.
    static let standard = PerformNavigation()
}
