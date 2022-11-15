//
//  StoryListView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

struct ContentListView: View {
    // MARK: Properties
    
    // retrieve the txtcompl view model from the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // retrieve the story list view model where the data is managed
    @StateObject private var viewModel = ContentListViewVM()
    // retrieve our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    // fetch the Story entity in Core Data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var stories: FetchedResults<Story>
    @State private var listOfStories: [Story] = []
    @State private var deletionIndexSet: IndexSet = []
    @State private var isPresentingConfirm: Bool = false
    @State private var confirmDeletion: Bool = false
    // toggle it to get the past seven days of stories or all of it
    @Binding var isShowingRecentList: Bool
    // toggle it to get the contents sent to trash list
    @Binding var isShowingTrashList: Bool
    var confirmMessage: String = """
    Are you sure you want to permanently erase the selected page?
    Erasing the page permanently deletes it.
    You cannot undo this action.
    """
    
    var body: some View {
        List {
            // for each story in the array, create a listing row. added as modifier the swipe to delete feature
            ForEach(listOfStories, id: \.self) { item in // content: StoryListRowView.init
                StoryListRowView(story: item, showTrashBin: $isShowingTrashList)
            }
            .onDelete(perform: isShowingTrashList ? presentConfirmDelete : sendToTrashBin)
        }
        .onAppear {
            self.listOfStories = coreDataContent
            emptyTrashBin()
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
            Button("Erase", role: .destructive) {
                deleteContent()
            }
        } message: {
            Text(confirmMessage)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingStoryEditorScreen, onDismiss: {
            self.isShowingRecentList = false
        }, content: {
            NavigationView {
                NewPageView()
            }
        })
        .fullScreenCover(isPresented: $viewModel.isShowingSearchScreen) { SearchView() }
        .fullScreenCover(isPresented: $viewModel.isShowingAccountScreen) { AccountView() }
        .navigationTitle(pageTitle())
        .toolbar {
            MainToolbar(isShowingNewPage: $viewModel.isShowingStoryEditorScreen, isShowingAccount: $viewModel.isShowingAccountScreen)
        }
        .overlay(MagnifyingGlass(showSearchScreen: $viewModel.isShowingSearchScreen), alignment: .bottomTrailing)
    }
    
    // here we return all the contents in CoreData, the last seven days, or contents in TrashBin
    var coreDataContent: [Story] {
        get {
            var fetchedStories: [Story] = []
            
            if !isShowingRecentList {
                fetchedStories.append(contentsOf: stories)
            } else if isShowingRecentList {
                // filter returns stories from the last seven days.
                let sortedByDate = stories.filter {
                    guard let unwrappedValue = $0.dateCreated else {
                        return false
                    }
                    return unwrappedValue > (Date.now - 604_800) // 604800 sec. is seven days in seconds
                }
                fetchedStories.append(contentsOf: sortedByDate)
            } else if isShowingTrashList {
                let discardedContent = stories.filter {
                    return $0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: discardedContent)
            }
            
            return fetchedStories
        }
    }
    
    private func sendToTrashBin(at offsets: IndexSet) {
        for offset in offsets {
            let story = stories[offset]
            
            //update the discarded story atributes in CoreData
            moc.performAndWait {
                story.isDiscarded = true
                story.dateDiscarded = Date.now
                PersistenceController.shared.saveContext()
            }
            
            // remove the item in question from the list
            listOfStories.remove(at: offset)
        }
    }
    // TODO: Confirmation Dialog View to ask the user for Confirmation Before Actual Deletion
    private func presentConfirmDelete(for offsets: IndexSet) {
        // pass the values of offsets to a State variable
        deletionIndexSet = offsets
        // toggle switch to show confirmation dialog
        self.isPresentingConfirm.toggle()
    }
    
    private func deleteContent() {
        for offset in deletionIndexSet {
            let story = stories[offset]
            
            // remove the item in question from the list and...
            listOfStories.remove(at: offset)
            
            // delete from CoreData
            moc.delete(story)
        }

        // write the changes out to persistent storage
        PersistenceController.shared.saveContext()
    }
    
    private func emptyTrashBin() {
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
