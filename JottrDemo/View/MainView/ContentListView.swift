//
//  ContentListView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//
// source code for fileExporter from
// https://stackoverflow.com/questions/65993146/swiftui-2-0-export-images-with-fileexporter-modifier &
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-export-files-using-fileexporter

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct TrashNotice: View {
    @Binding var showTrashNotice: Bool
    
    var body: some View {
        if showTrashNotice {
            Text("Contents are available here for 30 days. After that time, contents will be permanently deleted. This may take up to 40 days.")
                .font(.caption)
        }
    }
}

struct ContentListView: View {
    // MARK: Properties
    
    // retrieve the txtcompl view model from the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // retrieve the story list view model where the data is managed
    @StateObject var viewModel = ContentListViewVM()
    // retrieve our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    // fetch the Story entity in Core Data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)])
    var stories: FetchedResults<Story>
    // toggle it to get the past seven days of stories or all of it
    @Binding var isShowingRecentList: Bool
    // toggle it to get the contents sent to trash list
    @Binding var isShowingTrashList: Bool
    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        List {
            TrashNotice(showTrashNotice: $isShowingTrashList)
                .listRowSeparator(.hidden)
            
            // for each story in the array, create a listing row. added as modifier the swipeActions
            ForEach(viewModel.listOfStories, id: \.self) { content in
                ContentListRowView(story: content, showTrashBin: $isShowingTrashList)
                    .swipeActions(allowsFullSwipe: false) {
                        if isShowingTrashList {
                            Button(role: .destructive, action: { presentConfirmDelete(of: content) }, label: {
                                Label("Delete", systemImage: "trash")
                            })
                            
                            Button(action: { undoDiscard(of: content) }, label: {
                                Label("Undo", systemImage: "trash.slash")
                            })
                                .tint(.indigo)
                        } else {
                            Button(role: .destructive, action: { discardToTrashBin(of: content) }, label: {
                                Label("Trash Bin", systemImage: "trash")
                            })
                        }
                        
                        Button(action: { showFileOptions(textToExport: content) }, label: {
                            Label("Export", systemImage: "arrow.up.doc")
                        })
                            .tint(.blue)
                    }
            }
            .onReceive(self.didSave) { _ in // here is the listener for published context event
                loadList()
            }
        }
        .onAppear {
            loadList()
            emptyTrashBin()
        }
        .confirmationDialog("Are you sure?", isPresented: $viewModel.isPresentingConfirm) {
            Button("Erase", role: .destructive) {
                deleteContent()
            }
        } message: {
            Text(viewModel.confirmMessage)
        }
        .confirmationDialog("Export as...", isPresented: $viewModel.showingFileOptions, titleVisibility: .visible) {
            Button("Text", action: { showTextExporter(with: .plainText) })
            Button("PDF", action: { showTextExporter(with: .pdf) })
            Button("ePub", action: { showTextExporter(with: .epub) })
        }
        .fileExporter(isPresented: $viewModel.showingTextExporter, document: TextFile(initialText: viewModel.exportText), contentType: viewModel.givingContentType) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingNewPageScreen, onDismiss: {
            self.isShowingRecentList = false
            self.isShowingTrashList = false
        }, content: {
            NavigationView {
                NewPageView()
            }
        })
        .fullScreenCover(isPresented: $viewModel.isShowingSearchScreen) { SearchView() }
        .fullScreenCover(isPresented: $viewModel.isShowingAccountScreen) { AccountView() }
        .navigationTitle(pageTitle())
        .toolbar {
            MainToolbar(
                isShowingNewPage: $viewModel.isShowingNewPageScreen.onChange(launchNewPage),
                isShowingAccount: $viewModel.isShowingAccountScreen
            )
        }
        .overlay(MagnifyingGlass(showSearchScreen: $viewModel.isShowingSearchScreen), alignment: .bottomTrailing)
    }
    
    // here we return either all the contents in CoreData, the last seven days, or contents in TrashBin
    var coreDataContent: [Story] {
        get {
            var fetchedStories: [Story] = []
            
            let contentList = (isShowingRecentList, isShowingTrashList)
            switch contentList {
            case (false, false):
                // filter returns all contents that hasn't been discarded
                let unDiscardedContent = stories.filter {
                    return !$0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: unDiscardedContent)
            case (true, false):
                // filter returns content that hasn't been discarded from the last seven days.
                let sortedByDate = stories.filter {
                    guard let unwrappedValue = $0.dateCreated else {
                        return false
                    } // 604800 sec. is about seven days in seconds
                    return unwrappedValue > (Date.now - 604_800) && !$0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: sortedByDate)
            case (false, true):
                // filter return content that has been discarded
                let discardedContent = stories.filter {
                    return $0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: discardedContent)
            case (true, true):
                // if all else fail return an empty array
                return [] // TODO: maybe return an error message
            }
            
            return fetchedStories
        }
    }
}
