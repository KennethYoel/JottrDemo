//
//  StoryListView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation

extension ContentListView {
    // MARK: Manages The Data(the logic)
    
    class ContentListViewVM: ObservableObject {
        @Published var isShowingLoginScreen: Bool = false
        @Published var isShowingStoryEditorScreen: Bool = false
        @Published var isShowingAccountScreen: Bool = false
        @Published var isShowingSearchScreen: Bool = false
        @Published var isActive: Bool = false
    }
    
    func pageTitle() -> String {
        var title: String!
        if isShowingRecentList {
            let pastDateResults = (Date.now - 604800).formatted(date: .abbreviated, time: .omitted)
            title = "As of " + pastDateResults
        } else if isShowingTrashList {
            title = "Trash"
        } else {
            title = "Collection"
        }
        
        return title
    }
}
