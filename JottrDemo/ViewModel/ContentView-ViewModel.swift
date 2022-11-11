//
//  NoteBookView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation

extension ContentView {
    @MainActor class ContentViewVM: ObservableObject {
        // MARK: Properties
        
        @Published var isShowingLoginScreen: Bool = false
        @Published var isShowingSearchScreen: Bool = false
        @Published var isShowingStoryListView: Bool = false
        @Published var isShowingNewPageScreen: Bool = false
        @Published var isShowingAccountScreen: Bool = false
        @Published var isShowingSettingsScreen: Bool = false
        @Published var isHidden: Bool = false
        
        // MARK: Methods
        
        func showStoryEditor() {
            isShowingNewPageScreen.toggle()
        }
        
        func showAccountScreen() {
            isShowingAccountScreen.toggle()
        }
    }
}
