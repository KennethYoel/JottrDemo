//
//  StoryListDetailView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation

extension StoryListDetailView {
    // MARK: Manages The Data(the logic)
    
    @MainActor class StoryListDetailVM: ObservableObject {
        @Published var isShowingNewPageScreen: Bool = false
        @Published var isShowingPromptEditorScreen: Bool = false
        @Published var isShowingEditorToolbar: Bool = false
        @Published var isShareViewPresented: Bool = false
        @Published var isSendingContent: Bool = false
        // control whether we’re showing the delete confirmation alert or not
        @Published var showingDeleteAlert = false
    }
    
    // MARK: Helper Methods
    
    func hideKeyboardAndSave() {
        isInputActive = false
        updateContext()
    }
    
    func sendToStoryMaker(_ value: Bool) {
        if value {
            Task {
                await txtComplVM.generateStory()
            }
            updateContext()
        }
    }
    
    func launchNewPage(_ value: Bool) {
        if value {
            updateContext()
            txtComplVM.sessionStory = ""
            viewModel.isShowingNewPageScreen.toggle()
        }
    }
    
    func exportToFile() {
        
    }
    
    func storyToShare() -> String {
        let sheet = """
        \(txtComplVM.sessionStory)
        """
        return sheet
    }
    
    func presentShareView() {
        viewModel.isShareViewPresented.toggle()
    }
    
    func updateContext() {
        //update the saved story
        moc.performAndWait {
            story.complStory = self.txtComplVM.sessionStory
            PersistenceController.shared.saveContext()
        }
    }
    
    func deleteBook() {
        // delete from in memory storage
        moc.delete(story)
        
        // write the changes out to persistent storage
        PersistenceController.shared.saveContext()
        
        // hide current view
        dismissDetailView()
    }
}
