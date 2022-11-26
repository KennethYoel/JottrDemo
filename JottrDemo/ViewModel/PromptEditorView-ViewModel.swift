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
        @Published var isDismiss: Bool = false
        
        // MARK: Methods
        
        // shows popover content
        func showThemePopover() {
            self.explainerContent = .themeExplainer
            self.isShowingThemePopover.toggle()
            if self.isShowingThemePopover {
                self.isShowingPremisePopover = false
            }
        }
        
        func showPremisePopover() {
            self.explainerContent = .premiseExplainer
            self.isShowingPremisePopover.toggle()
            if self.isShowingPremisePopover {
                self.isShowingThemePopover = false
            }
        }
    }
    
    // MARK: Helper Methods
    
    // notifies NewPageView to submit the prompt user has created for the AI story generator
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
