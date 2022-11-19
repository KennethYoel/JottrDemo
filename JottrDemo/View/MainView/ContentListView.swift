//
//  ContentListView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//
// source code for fileExporter from
// https://stackoverflow.com/questions/65993146/swiftui-2-0-export-images-with-fileexporter-modifier

import Foundation
import SwiftUI
import UniformTypeIdentifiers

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
    
    @State private var showingFileOptions: Bool = false
    @State private var showingPlainTextExporter: Bool = false
    @State private var showingPDFExporter: Bool = false
    @State private var target: String = ""
    
    var body: some View {
        List {
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
                        
                        Button(action: {
                            self.target = content.wrappedComplStory
                            self.showingFileOptions.toggle()
//                            self.showingExporter.toggle()
                        }, label: {
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
        .fileExporter(isPresented: $showingPlainTextExporter, document: PlainTextFile(initialText: target), contentType: .plainText) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .fileExporter(isPresented: $showingPDFExporter, document: PDFFile(initialPDF: target), contentType: .pdf) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $viewModel.isPresentingConfirm) {
            Button("Erase", role: .destructive) {
                deleteContent()
            }
        } message: {
            Text(viewModel.confirmMessage)
        }
        .confirmationDialog("Choose a file type", isPresented: $showingFileOptions, titleVisibility: .visible) {
            Button("Plain Text") {
                self.showingPlainTextExporter.toggle()
            }
            
            Button("PDF") {
                self.showingPDFExporter.toggle()
            }
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

//struct PlainTextFile: FileDocument {
//    // tell the system we support only pdf
//    static var readableContentTypes = [UTType.plainText] // TODO: can change to .pdf but dont know if it readable
//    
//    // by default our document is empty
//    var text = ""
//    
//    // a simple initializer that creates new, empty documents
//    init(initialText: String = "") {
//       text = initialText
//    }
//    
//    // this initializer loads data that has been saved previously
//    init(configuration: ReadConfiguration) throws {
//        if let data = configuration.file.regularFileContents {
//            text = String(decoding: data, as: UTF8.self)
//        } else {
//            throw CocoaError(.fileReadCorruptFile)
//        }
//    }
//    
//    // this will be called when the system wants to write our data to disk
//    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//        let data = Data(text.utf8)
//        return FileWrapper(regularFileWithContents: data)
//    }
//}
