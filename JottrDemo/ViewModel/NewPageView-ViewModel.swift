//
//  NewPageView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/6/22.
//

import Foundation
import SwiftUI

extension NewPageView {
    @MainActor class NewPageViewVM: ObservableObject {
        // MARK: Properties
        
//        @Published var storyEditorPlaceholder: String = "Perhap's we can begin with once upon a time..."
        @Published var isSearchViewPresented: Bool = false
        @Published var isShareViewPresented: Bool = false
        @Published var isShowingPromptEditorScreen: Bool = false
        @Published var isShowingEditorToolbar: Bool = false
        @Published var isShowingStoryEditorScreen: Bool = false
        @Published var isSubmittingPromptContent: Bool = false
        @Published var isKeyboardActive: Bool = false
        @Published var id: UUID = UUID()
    }
    
    func reload() {
        save()
        txtComplVM.sessionStory = ""
        viewModel.id = UUID()
    }
}
