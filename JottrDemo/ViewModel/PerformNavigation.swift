//
//  ActivateNavigation.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/31/22.
//

import Foundation

class PerformNavigation: ObservableObject {
    @Published var savedViewState: String = ""
    // add isActive for StoryListView and the StoryListDetail
    
    // used as @ObservedObject var <nameOfVariable>: PerformNavigation = .standard, so the class is initialzed from within the class itself.
    static let standard = PerformNavigation()
}
