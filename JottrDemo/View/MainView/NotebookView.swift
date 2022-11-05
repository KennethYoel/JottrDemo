//
//  NoteBookView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

// sub-view of introduction section
struct InfoSectionView: View {
    @Binding var viewHidden: Bool
    
    var body: some View {
        if !viewHidden {
            Text("Intro")
                .headerStyle()
        }
    }
}

// sub-view of hidesectionview and notebokview
struct HideSectionView: View {
    // MARK: Properties
    
    @Binding var isHidden: Bool
    
    var body: some View {
        Menu("...") {
            if !isHidden {
                Button(action: collapse, label: {
                    Label("Collapse", systemImage: "rectangle.compress.vertical")
                })
            } else {
                Button(action: expand, label: {
                    Label("Expand", systemImage: "rectangle.expand.vertical")
                })
            }
        }
        .font(.system(.caption, design: .serif))
    }
    
    // MARK: Methods
    
    private func collapse() {
        isHidden.toggle()
    }

    private func expand() {
        isHidden.toggle()
    }
}

// composite main view
struct NotebookView: View {
    // MARK: Properties
    
    // view receives the TxtComplViewModel object in the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @StateObject var viewModel = NotebookViewVM()
    @State private var isStoryListActive: Bool = false
    
    var body: some View {
        List {
            Section {
                // a link to a list of stories
                NavigationLink(isActive: $isStoryListActive) {
                    ContentView(loadingState: .storyList(false))
                } label: {
                    Label("Collection", systemImage: "archivebox")
                        .headerStyle()
                }
                .buttonStyle(.plain)
                
                // a link to a list of stories written in the past seven days
                NavigationLink {
                    ContentView(loadingState: .storyList(true))
                } label: {
                    Label("Recent", systemImage: "deskclock")
                        .headerStyle()
                }
                .buttonStyle(.plain)
                
                // a link to a list of stories the user recently deleted
                NavigationLink {
//                    self.currentView = .storyList
//                    StoryListView()
                } label: {
                    Label("Trash", systemImage: "trash")
                        .headerStyle()
                }
                .buttonStyle(.plain)
            }
            
            Section {
                InfoSectionView(viewHidden: $viewModel.isHidden)
            } header: {
                HStack {
                    Text("INTRODUCTION")
                        .captionStyle()
                    Spacer()
                    HideSectionView(isHidden: $viewModel.isHidden)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingStoryEditorScreen, onDismiss: {
            isStoryListActive.toggle()
        }, content: {
            NavigationView {
                StoryEditorView()
            }
        })
        .fullScreenCover(isPresented: $viewModel.isShowingAccountScreen) { AccountView()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingSearchScreen) {
            SearchView()
        }
        .overlay(MagnifyingGlass(showSearchScreen: $viewModel.isShowingSearchScreen), alignment: .bottomTrailing)
        .navigationTitle("🖋Jottr")
        .toolbar {
            MainToolbar(isShowingStoryEditor: $viewModel.isShowingStoryEditorScreen, isShowingAccount: $viewModel.isShowingAccountScreen)
        }
    }
}

struct NotebookView_Previews: PreviewProvider {
    static var previews: some View {
        NotebookView()
    }
}
