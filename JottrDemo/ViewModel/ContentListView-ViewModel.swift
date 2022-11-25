//
//  ContentListView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation
import UniformTypeIdentifiers

extension ContentListView {
    // MARK: Manages The Data(the logic)
    
    class ContentListViewVM: ObservableObject {
        //MARK: Properties
        
        // collection properties
        @Published var listOfStories: [Story] = []
        @Published var contentToBeRemoved: Story? = nil
        // toolbar properties
        @Published var isPresentingConfirm: Bool = false
        @Published var confirmDeletion: Bool = false
        @Published var isShowingLoginScreen: Bool = false
        @Published var isShowingNewPageScreen: Bool = false
        @Published var isShowingAccountScreen: Bool = false
        @Published var isShowingSearchScreen: Bool = false
        @Published var isActive: Bool = false
        @Published var confirmMessage: String = """
        Are you sure you want to permanently erase the selected page?
        Erasing the page permanently deletes it.
        You cannot undo this action.
        """
        // export properties
        @Published var showingFileOptions: Bool = false
        @Published var showingTextExporter: Bool = false
        @Published var givingContentType: UTType = .plainText
        @Published var exportText: String = ""
    }
    
    // MARK: Helper Methods
    
    func pageTitle() -> String {
        // updates the navigatonTitle
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
    
    func loadList() {
        // loads when view forst appear and reloads the list for every persistence store save
        viewModel.listOfStories = coreDataContent
    }
    
    func launchNewPage(_ value: Bool) {
        if value {
            self.txtComplVM.sessionStory = ""
        }
    }
    
    func showFileOptions(textToExport: Story) {
        viewModel.exportText = textToExport.wrappedComplStory
        viewModel.showingFileOptions.toggle()
    }
    
    func showTextExporter(with contentType: UTType) {
        viewModel.givingContentType = contentType
        viewModel.showingTextExporter.toggle()
    }
    
    func presentConfirmDelete(of rowContent: Story) { //for offsets: IndexSet
        // pass the value of storyContent to a storyToBeRemoved variable
        viewModel.contentToBeRemoved = rowContent
        
        // toggle switch to show confirmation dialog
        viewModel.isPresentingConfirm.toggle()
    }
    
    func deleteContent() {
        // get the content to be removed from the Published variable
        let story = viewModel.contentToBeRemoved
        
        // delete from CoreData
        guard let data = story else { return }
        moc.delete(data)

        // write the changes out to persistent storage
        PersistenceController.shared.saveContext()
    }
    
    func undoDiscard(of rowContent: Story) {
        // move the content back to collection list
        let story = rowContent
        
        //change the discarded story atributes in CoreData
        moc.performAndWait {
            story.isDiscarded = false
            story.dateDiscarded = nil
            PersistenceController.shared.saveContext()
        }
    }
    
    func discardToTrashBin(of rowContent: Story) {
        // move the content to trash bin
        let story = rowContent
        
        //change the discarded content atributes in CoreData
        moc.performAndWait {
            story.isDiscarded = true
            story.dateDiscarded = Date.now
            PersistenceController.shared.saveContext()
        }
    }
    
    func emptyTrashBin() {
        // after 30 days any content marked as isDiscarded in persistent storage will be permanently deleted
        if isShowingTrashList {
            let toBeDiscarded = stories.filter {
                guard let unwrappedValue = $0.dateDiscarded else {
                    return false
                } // need to confirm this--need to have a list of content older than 30 days
                return unwrappedValue < (Date.now - 78_918_677) // 30 months is about 78,918,677 seconds
            }
            
            for item in toBeDiscarded {
                moc.delete(item)
            }
            
            // write the changes out to persistent storage
            PersistenceController.shared.saveContext()
        }
    }
}
