//
//  NoteBookView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation

extension NotebookView {
    @MainActor class NotebookViewVM: ObservableObject {
        // MARK: Properties
        
        @Published var isShowingLoginScreen: Bool = false
        @Published var isShowingSearchScreen: Bool = false
        @Published var isShowingStoryListView: Bool = false
        @Published var isShowingStoryEditorScreen: Bool = false
        @Published var isShowingAccountScreen: Bool = false
        @Published var isShowingSettingsScreen: Bool = false
        @Published var isHidden: Bool = false
        
        // MARK: Methods
        
        func showStoryEditor() {
            isShowingStoryEditorScreen.toggle()
        }
        
        func showAccountScreen() {
            isShowingAccountScreen.toggle()
        }
    }
}
