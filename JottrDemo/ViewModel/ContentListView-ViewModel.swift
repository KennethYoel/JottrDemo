//
//  ContentListView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation

extension ContentListView {
    // MARK: Manages The Data(the logic)
    
    class ContentListViewVM: ObservableObject {
//        @Published var deletionIndexSet: IndexSet = []
        @Published var deletionIndexSet: Int? = nil
        @Published var storyToBeRemoved: Story? = nil
        @Published var isPresentingConfirm: Bool = false
        @Published var confirmDeletion: Bool = false
        @Published var isShowingLoginScreen: Bool = false
        @Published var isShowingStoryEditorScreen: Bool = false
        @Published var isShowingAccountScreen: Bool = false
        @Published var isShowingSearchScreen: Bool = false
        @Published var isActive: Bool = false
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
    
    func discardToTrashBin(at offset: Int, of storyContent: Story) { //IndexSet
        // move the content into the trash bin for later deletion
//        let story = storyContent //stories[offsets]
        
        // remove the item in question from the list and then...
        listOfStories.remove(at: offset)
        // add the removed story to trashList...
        trashList.append(storyContent)
        
        //update the discarded story atributes in CoreData
        moc.performAndWait {
            storyContent.isDiscarded = true
            storyContent.dateDiscarded = Date.now
            PersistenceController.shared.saveContext()
        }
        
        debugPrint("offset: \(offset) story: \(storyContent)")
//        for offset in offsets {
//
//        }
    }
    // TODO: refresh fetchrequest somehow
    func undoDiscard(for offset: Int, of storyContent: Story) {
        // from source: IndexSet, to destination: Int -> Void 
        debugPrint("Testing Undo")
        
        // move the content back to collection list
        let story = storyContent
        
        //update the discarded story atributes in CoreData
        moc.performAndWait {
            story.isDiscarded = false
            PersistenceController.shared.saveContext()
        }
        
        // remove the item in question from the trashList and then...
        trashList.remove(at: offset) // TODO: search story by id and remove that one
        // ...add the removed item to listOfStories
        listOfStories.append(story)
    }
    
    func presentConfirmDelete(for offset: Int, of storyContent: Story) { //for offsets: IndexSet
        // pass the values of offsets to a State variable
        viewModel.deletionIndexSet = offset
        viewModel.storyToBeRemoved = storyContent
        // toggle switch to show confirmation dialog
        self.viewModel.isPresentingConfirm.toggle()
    }
    
    func deleteContent() {
        // remove the item in question from the list and...
        listOfStories.remove(at: viewModel.deletionIndexSet!)
        
        // get the list IndexSet from the State variable
        let story = viewModel.storyToBeRemoved //stories[viewModel.deletionIndexSet!]
        
        // delete from CoreData
        guard let data = story else { return }
        moc.delete(data)
        
//        for offset in viewModel.deletionIndexSet {
//
//        }

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
