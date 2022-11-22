//
//  ContentListDetailView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import UniformTypeIdentifiers

extension ContentListDetailView {
    // MARK: Manages The Data(the logic)
    
    @MainActor class ContentListDetailVM: ObservableObject {
        // toolbar properties
        @Published var isShowingNewPageScreen: Bool = false
        @Published var showingFileOptions: Bool = false
        @Published var isShareViewPresented: Bool = false
        @Published var isShowingPromptEditorScreen: Bool = false
        @Published var isSendingContent: Bool = false
        // export properties
        @Published var showingTextExporter: Bool = false
        @Published var givingContentType: UTType = .plainText
        @Published var exportText: String = ""
    }
    
    // MARK: Helper Methods
    
    func hideKeyboardAndSave() {
        isInputActive = false
        updateContext()
    }
    
    func sendToContentMaker(_ value: Bool) {
        if value {
            Task {
                await txtComplVM.generateStory()
            }
            updateContext()
        }
    }
    
    func showTextExporter(with contentType: UTType) {
        viewModel.givingContentType = contentType
        viewModel.showingTextExporter.toggle()
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
        if !txtComplVM.sessionStory.isEmpty {
            //add a story
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
