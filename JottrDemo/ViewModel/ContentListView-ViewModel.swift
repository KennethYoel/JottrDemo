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
        @Published var listOfStories: [Story] = []
        @Published var deletionIndexSet: IndexSet = []
        @Published var isPresentingConfirm: Bool = false
        @Published var confirmDeletion: Bool = false
        @Published var isShowingLoginScreen: Bool = false
        @Published var isShowingStoryEditorScreen: Bool = false
        @Published var isShowingAccountScreen: Bool = false
        @Published var isShowingSearchScreen: Bool = false
        @Published var isActive: Bool = false
        @Published var resetList: Bool = false
        @Published var confirmMessage: String = """
        Are you sure you want to permanently erase the selected page?
        Erasing the page permanently deletes it.
        You cannot undo this action.
        """
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
    
    func discardToTrashBin(at offsets: IndexSet) {
        // move the content into the trash bin for later deletion
        for offset in offsets {
            let story = stories[offset]
            
            //update the discarded story atributes in CoreData
            moc.performAndWait {
                story.isDiscarded = true
                story.dateDiscarded = Date.now
                PersistenceController.shared.saveContext()
            }
            
            // remove the item in question from the list
            viewModel.listOfStories.remove(at: offset)
        }
    }
    // TODO: 
    func undoDiscard(from source: IndexSet, to destination: Int) -> Void {
        //Optional<(IndexSet, Int) -> Void>
    }
    
    func presentConfirmDelete(for offsets: IndexSet) {
        // pass the values of offsets to a State variable
        viewModel.deletionIndexSet = offsets
        // toggle switch to show confirmation dialog
        self.viewModel.isPresentingConfirm.toggle()
    }
    
    func deleteContent() {
        // get the list IndexSet from the State variable
        for offset in viewModel.deletionIndexSet {
            let story = stories[offset]
            
            // remove the item in question from the list and...
            viewModel.listOfStories.remove(at: offset)
            
            // delete from CoreData
            moc.delete(story)
        }

        // write the changes out to persistent storage
        PersistenceController.shared.saveContext()
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
