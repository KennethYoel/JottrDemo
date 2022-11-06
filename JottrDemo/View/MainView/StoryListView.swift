//
//  StoryListView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

struct StoryListView: View {
    // MARK: Properties
    
    // retrieve the txtcompl view model from the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // retrieve the story list view model where the data is managed
    @StateObject private var viewModel = StoryListViewVM()
    // retrieve our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    // fetch the Story attribute in Core Data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)]) var stories: FetchedResults<Story>
    // toggle it to get the past seven days of stories or all of it
    var isShowingRecentList: Bool = false
    
    var body: some View {
        List {
            // for each story in the array, create a listing row
            ForEach(listOfStories, content: StoryListRowView.init).onDelete(perform: deleteStory) // swipe to delete
        }
        .fullScreenCover(isPresented: $viewModel.isShowingStoryEditorScreen, content: {
            NavigationView {
                NewPageView()
            }
        })
        .fullScreenCover(isPresented: $viewModel.isShowingSearchScreen) { SearchView() }
        .fullScreenCover(isPresented: $viewModel.isShowingAccountScreen) { AccountView() }
        .navigationTitle(pageTitle())
        .toolbar {
            MainToolbar(isShowingStoryEditor: $viewModel.isShowingStoryEditorScreen, isShowingAccount: $viewModel.isShowingAccountScreen)
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
    
    private func deleteStory(at offsets: IndexSet) {
        for offset in offsets {
            let story = stories[offset]
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
