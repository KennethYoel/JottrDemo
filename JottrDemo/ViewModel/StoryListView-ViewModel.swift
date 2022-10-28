//
//  StoryListView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation

extension StoryListView {
    class StoryListViewVM: ObservableObject {
        @Published var isShareViewPresented: Bool = false
        @Published var isShowingLoginScreen: Bool = false
        @Published var isShowingStoryEditorScreen: Bool = false
        @Published var isShowingFeedbackScreen: Bool = false
        @Published var isShowingSettingsScreen: Bool = false
        @Published var isShowingSearchScreen: Bool = false
        @Published var isActive: Bool = false
    }
    
    func pageTitle() -> String {
        var title: String!
        if !isShowingRecentList {
            title = "Collection"
        } else {
            let pastDateResults = (Date.now - 604800).formatted(date: .abbreviated, time: .omitted)
            title = "As of " + pastDateResults
        }
        
        return title
    }
}
