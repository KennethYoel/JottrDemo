//
//  ContentView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 9/24/22.
//

import Foundation
import SwiftUI

// defining loading state of the app
enum LoadingState: String {
    case notebook, storyList, recentStoryList, storyListDetail, trashList, trashListDetail
}

// sub-view of story section
struct PageListSectionView: View {
    // MARK: Properties
    @State var showRecentList: Bool
    @State var showTrashList: Bool
    var tagValue: String
    @Binding var currentView: String?
    var labelTitle: String
    var labelImage: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            // a link to the list view
            NavigationLink(
                "",
                destination: PageListView(isShowingRecentList: $showRecentList, isShowingTrashList: $showTrashList),
                tag: tagValue,
                selection: $currentView
            )
            Button {
                self.currentView = tagValue
            } label: {
                Label(labelTitle, systemImage: labelImage)
                    .subHeaderStyle()
            }
            .buttonStyle(.plain)
        }
    }
}

// sub-view of introduction section
struct InfoSectionView: View {
    // MARK: Properties
    @Binding var viewHidden: Bool
    
    var body: some View {
        if !viewHidden {
            Text("Intro")
                .subSecondaryStyle()
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
struct ContentView: View {
    // MARK: Properties
    
    // view receives the NetworkMonitor object in the environment
    @EnvironmentObject var network: NetworkMonitor
    // view receives the TxtComplViewModel object in the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @StateObject var viewModel = ContentViewVM()
    // store the default loading state and programmatically activate navigation link
    @SceneStorage("ContentView.CurrenView") var currentView: String?
    // present alert view if network if inactive
    @State private var showNetworkAlert: Bool = false
    @State private var isStoryListActive: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    // link to a all stories saved to CoreData
                    PageListSectionView(
                        showRecentList: false,
                        showTrashList: false,
                        tagValue: LoadingState.storyList.rawValue,
                        currentView: $currentView,
                        labelTitle: "Entirety",
                        labelImage: "archivebox"
                    )

                    // link to a list of stories written in the past seven days
                    PageListSectionView(
                        showRecentList: true,
                        showTrashList: false,
                        tagValue: LoadingState.recentStoryList.rawValue,
                        currentView: $currentView,
                        labelTitle: "Recent",
                        labelImage: "deskclock"
                    )
                    
                    // link to a list of stories the user recently deleted
                    PageListSectionView(
                        showRecentList: false,
                        showTrashList: true,
                        tagValue: LoadingState.trashList.rawValue,
                        currentView: $currentView,
                        labelTitle: "Trash",
                        labelImage: "trash"
                    )
                }
                
                Section {
                    // link to introduction information
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
            .onAppear {
                if !network.isActive {
                    showNetworkAlert.toggle()
                }
            }
            .alert(isPresented: $showNetworkAlert) {
                Alert(title: Text("Device Offline"),
                      message: Text("Turn Off AirPlane Mode or Use Wi-Fi to Access Data"),
                      dismissButton: .default(
                        Text("OK")
                      )
                )
            }
            .fullScreenCover(isPresented: $viewModel.isShowingNewPageScreen, onDismiss: {
                self.currentView = LoadingState.storyList.rawValue
            }, content: {
                NavigationView {
                    EditorView()
                }
            })
            .sheet(isPresented: $viewModel.isShowingAccountScreen) {
                AccountView()
            }
            .fullScreenCover(isPresented: $viewModel.isShowingSearchScreen) {
                SearchView()
            }
            .overlay(MagnifyingGlass(showSearchScreen: $viewModel.isShowingSearchScreen), alignment: .bottomTrailing)
            .navigationTitle("Collection🖋")
            .toolbar {
                MainToolbar(isShowingNewPage: $viewModel.isShowingNewPageScreen, isShowingAccount: $viewModel.isShowingAccountScreen)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
