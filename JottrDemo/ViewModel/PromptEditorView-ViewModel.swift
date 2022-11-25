//
//  PromptEditorView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/24/22.
//

import Foundation

extension PromptEditorView {
    // MARK: Manages The Data(the logic)
    
    @MainActor class PromptEditorViewVM: ObservableObject {
        // MARK: Properties
        
        @Published var explainerContent: Explainer = .themeExplainer
        @Published var isShowingThemePopover: Bool = false
        @Published var isShowingPremisePopover: Bool = false
        @Published var isShowingBannedPopover: Bool = false
    }
    
    // MARK: Helper Methods
    
    func addPrompt() {
        submitPromptContent = true
        dismissPromptEdit()
    }

    // function to keep text length in limits
    func limitText(_ upper: Int) {
        if txtComplVM.customTheme.count & txtComplVM.sessionStory.count > upper {
            txtComplVM.customTheme = String(txtComplVM.customTheme.prefix(upper))
            txtComplVM.sessionStory = String(txtComplVM.promptLoader.prefix(upper))
        }
    }
}
