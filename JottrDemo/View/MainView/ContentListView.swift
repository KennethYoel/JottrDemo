//
//  ContentListView.swift
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
    @StateObject var viewModel = ContentListViewVM()
    // retrieve our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    // fetch the Story entity in Core Data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var stories: FetchedResults<Story>
    // toggle it to get the past seven days of stories or all of it
    @Binding var isShowingRecentList: Bool
    // toggle it to get the contents sent to trash list
    @Binding var isShowingTrashList: Bool
    // TODO: add the option for putting the content back from the trash bin
    @State var listOfStories: [Story] = []
    @State var trashList: [Story] = []
    @State var refresh: Bool = false
    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        List {
            /*
             for each story in the array, create a listing row. added as modifier the swipe to delete feature
             and added Array(.enumerated) - code from https://alejandromp.com/blog/swiftui-enumerated/
             */
            ForEach(listOfStories.indices, id: \.self) { index in // content: StoryListRowView.init
                ContentListRowView(story: listOfStories[index], showTrashBin: $isShowingTrashList)
                    .swipeActions(allowsFullSwipe: false) {
                        if isShowingTrashList {
                            Button(role: .destructive, action: { presentConfirmDelete(for: index, of: listOfStories[index]) }, label: {
                                Label("Delete", systemImage: "trash")
                            })
                            
                            Button(action: { undoDiscard(for: index, of: listOfStories[index]) }, label: {
                                Label("Undo", systemImage: "trash.slash")
                            })
                                .tint(.indigo)
                        } else {
                            Button(role: .destructive, action: { discardToTrashBin(at: index, of: listOfStories[index]) }, label: {
                                Label("Trash Bin", systemImage: "trash")
                            })
                        }
                    }
//                    .contextMenu {
//                        if isShowingTrashList {
//                            Button("Delete", action: { presentConfirmDelete(for: index) })
//                            Button("Undo", action: { undoDiscard(for: index) })
//                        } else {
//                            Button("Trash Bin", action: { discardToTrashBin(at: index) })
//                        }
//                    } // TODO: See Bottom For Solution
            }
            .onReceive(self.didSave) { _ in // here is the listener for published context event
                self.listOfStories = coreDataContent
            }
//            .onDelete(perform: isShowingTrashList ? presentConfirmDelete : discardToTrashBin)
//            .onMove(perform: undoDiscard)
        }
        .onAppear {
            self.listOfStories = coreDataContent
            emptyTrashBin()
        }
        .confirmationDialog("Are you sure?", isPresented: $viewModel.isPresentingConfirm) {
            Button("Erase", role: .destructive) {
                deleteContent()
            }
        } message: {
            Text(viewModel.confirmMessage)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingStoryEditorScreen, onDismiss: {
            self.isShowingRecentList = false
            self.isShowingTrashList = false
            // still no working need to fetch the data from CoreData
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
                // filter returns content that hasn't been discarded
                let unDiscardedContent = stories.filter {
                    return !$0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: unDiscardedContent)
            } else if isShowingRecentList {
                // filter returns content from the last seven days.
                let sortedByDate = stories.filter {
                    guard let unwrappedValue = $0.dateCreated else {
                        return false
                    }
                    return unwrappedValue > (Date.now - 604_800) // 604800 sec. is seven days in seconds
                }
                fetchedStories.append(contentsOf: sortedByDate)
            } else if isShowingTrashList {
                // filter return content that has been discarded
                let discardedContent = stories.filter {
                    return $0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: discardedContent)
            }
            
            return fetchedStories
        }
    }
}

// TODO: Try!

/*
 @State private var refreshing = false
 private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

 var body: some View {
     List {
         ForEach(fetchedResults) { primary in
             NavigationLink(destination: SecondaryView(primary: primary)) {
                 VStack(alignment: .leading) {
                     // below use of .refreshing is just as demo,
                     // it can be use for anything
                     Text("\(primary.primaryName ?? "nil")" + (self.refreshing ? "" : ""))
                     Text("\(primary.secondary?.secondaryName ?? "nil")").font(.footnote).foregroundColor(.secondary)
                 }
             }
             // here is the listener for published context event
             .onReceive(self.didSave) { _ in
                 self.refreshing.toggle()
             }
         }
     }
     .navigationBarTitle("Primary List")
     .navigationBarItems(trailing:
         Button(action: {self.addNewPrimary()} ) {
             Image(systemName: "plus")
         }
     )
 }
 */
