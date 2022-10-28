//
//  NoteBookView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

// composite views of hidesectionview and notebokview
struct HideSectionView: View {
    // MARK: Properties
    
    @Binding var isHidden: Bool
    
    var body: some View {
        Menu("...") {
            if !isHidden {
                Button(action: collapse, label: { Label("Collapse", systemImage: "rectangle.compress.vertical") })
            } else {
                Button(action: expand, label: { Label("Expand", systemImage: "rectangle.expand.vertical") })
            }
        }
        .font(.system(.caption, design: .serif))
    }
    
    private func collapse() {
        isHidden.toggle()
    }

    private func expand() {
        isHidden.toggle()
    }
}

// primary view
struct NotebookView: View {
    // MARK: Properties
    
    // this view receives the TxtComplViewModel object in the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @StateObject var viewModel = NotebookViewVM()
    // these two @State variable needs to be in this struct, values won't change when moved to ViewModel
    @State var isShowingStoryEditorScreen: Bool = false
    @State var isStoryListActive: Bool = false
    
    var body: some View {
        List {
            Section {
                // a link to a list of stories
                NavigationLink(isActive: $isStoryListActive) {
                    ContentView(loadingState: .storyList(false))
                } label: {
                    Label("Collection", systemImage: "archivebox")
                        .font(.custom("Futura", size: 13))
                }
                .buttonStyle(.plain)
                
                // a link to a list of stories written in the past seven days
                NavigationLink {
                    ContentView(loadingState: .storyList(true))
                } label: {
                    Label("Recent", systemImage: "deskclock")
                        .font(.custom("Futura", size: 13))
                }
                .buttonStyle(.plain)
                
                // a link to a list of stories the user recently deleted
                NavigationLink {
//                    self.currentView = .storyList
//                    StoryListView()
                } label: {
                    Label("Trash", systemImage: "trash")
                        .font(.custom("Futura", size: 13))
                }
                .buttonStyle(.plain)
            }
            
            Section {
                if !viewModel.isHidden {
                    Text("Intro")
                }
            } header: {
                HStack {
                    Text("INTRODUCTION")
                        .font(.system(.caption, design: .serif))
                    Spacer()
                    HideSectionView(isHidden: $viewModel.isHidden)
                }
            }
        } // MARK: Form Modyfiers
        .fullScreenCover(isPresented: $isShowingStoryEditorScreen, onDismiss: {
            isStoryListActive.toggle()
        }, content: {
            NavigationView {
                StoryEditorView()
            }
        })
        .fullScreenCover(isPresented: $viewModel.isShowingAccountScreen) { AccountView() }
        .sheet(isPresented: $viewModel.isShowingSearchScreen) { SearchView() }
        .overlay(MagnifyingGlass(showSearchScreen: $viewModel.isShowingSearchScreen), alignment: .bottomTrailing)
        .navigationTitle("🖋Jottr") //highlighter
        .toolbar { noteBookTopToolbar }
    }
    
    // MARK: External Properties
    // the property will be inline very nicely by the swift optimizer also when the body is re-computed, changed program state for example, swift will recall the properties as needed
    var noteBookTopToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: showStoryEditor, label: {
                Label("New Story", systemImage: "square.and.pencil")
            })
                .padding()
                .buttonStyle(.plain)
            
            Button(action: { viewModel.showAccountScreen() }, label: {
                Label("Account", systemImage: "ellipsis.circle")
            })
                .padding(.trailing)
                .buttonStyle(.plain)
            
//            Menu {
//                Button(action: showLoginScreen, label: {
//                    Label("Login", systemImage: "lanyardcard")
//                })
//
//                Button(action: showAccountScreen, label: {
//                    Label("Account", systemImage: "pencil.and.outline")
//                })
//
//                Button("Settings", action: showSettingsScreen)
//            } label: {
//                 Image(systemName: "gearshape.2")
//            }
        }
    }
}

struct NotebookView_Previews: PreviewProvider {
    static var previews: some View {
        NotebookView()
    }
}
