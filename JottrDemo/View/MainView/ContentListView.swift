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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)]) var stories: FetchedResults<Story>
    // fetch the TrashBin attribute in Core Data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateDiscarded", ascending: false)]) var trashBin: FetchedResults<TrashBin>
    // toggle it to get the past seven days of stories or all of it
    @Binding var isShowingRecentList: Bool
    @Binding var isShowingTrashList: Bool
    
    var body: some View {
        List {
            if isShowingTrashList {
                // for each story in the array, create a listing row. added as modifier the swipe to delete feature
                ForEach(listOfTrashContent, id: \.self) { content in
                    TrashListRowView(trash: content)
                }.onDelete(perform: deleteStory)
            } else {
                // for each story in the array, create a listing row. added as modifier the swipe to delete feature
                ForEach(listOfStories, content: StoryListRowView.init).onDelete(perform: deleteStory)
            }
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
    
    // either showing all the content in CoreData or the last seven days
    var listOfStories: [Story] {
        get {
            var fetchedStories: [Story] = []
            
            if !isShowingRecentList {
                fetchedStories.append(contentsOf: stories)
                return fetchedStories
            } else {
                // filter returns stories from the last seven days.
                let sortedByDate = stories.filter {
                    guard let unwrappedValue = $0.creationDate else {
                        return false
                    }
                    return unwrappedValue > (Date.now - 604_800) // 604800 sec. is seven days in seconds
                }
                fetchedStories.append(contentsOf: sortedByDate)
                
                return fetchedStories
            }
        }
    }
    
    var listOfTrashContent: [TrashBin] {
        get {
            var fetchedTrashed: [TrashBin] = []
            fetchedTrashed.append(contentsOf: trashBin)
            return fetchedTrashed
        }
    }
    
    private func deleteStory(at offsets: IndexSet) {
        let discard = TrashBin(context: moc)
        discard.dateDiscarded = Date()
        discard.origin = Story(context: moc)
        
        for offset in offsets {
            let story = stories[offset]
            
            discard.origin = story
            discard.origin?.addToTrashBin(discard)
            
            // delete from in memory storage
            moc.delete(story)
        }
        
        // write the changes out to persistent storage
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
