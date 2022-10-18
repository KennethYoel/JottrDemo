//
//  ContentView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 9/24/22.
//

import Foundation
import SwiftUI

enum LoadingState {
    case notebook, storyList(Bool), accountView
    
    var stringValue: String {
        switch self {
        case .notebook:
            return "notebook"
        case .storyList:
            return "storyList"
        case .accountView:
            return "accountView"
        }
    }
}

struct ContentView: View {
    // MARK: Properties
    
    @EnvironmentObject var network: NetworkMonitor
    @State private var showNetworkAlert: Bool = false
    var currentView = LoadingState.notebook
    // used for state restoration
//    @SceneStorage("reLaunchView") var reLaunchView = ""
//    @AppStorage("hasLauncehd") private var hasLaunched = false
    
    var body: some View {
        // initial view - a random quote page "I have been blessed with a wilder mind."
        switch currentView {
        case .notebook:
            NavigationView {
                NoteBookView()
                    .onAppear {
                        if !network.isActive {
                            showNetworkAlert.toggle()
                            UserDefaults.standard.object(forKey: "reLaunchView")
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
            }
        case .storyList(let showRecentList):
            StoryListView(isShowingRecentList: showRecentList)
        case .accountView:
            AccountView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//switch LoadingState {
//case .notebook:
//    IdleView()
////                .onAppear {
////                    Task {
////                        await viewModel.load(prompt: "This is a test.")
////                    }
////                }
//case .storyList:
//    ProgressView("Downloading…")
//case .storyEditor(let error):
//    ErrorView(isAnError: $failToLoad, error: error)
//case .loaded(let completedText):
//    LoadedView(txtData: completedText)
//}
//}

//struct IdleView: View {
//    var body: some View {
//        Image(systemName: "tortoise")
//            .padding()
//    }
//}
//
//struct ErrorView: View {
//    @EnvironmentObject var viewModel: TxtComplViewModel
//    @Binding var isAnError: Bool
//    var error: Error
//
//    var body: some View {
//        LoadedView()
//            .alert(isPresented: $isAnError) {
//                Alert(title: Text("Unable to Write a Story"),
//                      message: Text("\(error.localizedDescription)"),
//                      primaryButton: .default(
//                        Text("Try Again"),
//                        action: {
//                            Task {
//                                await viewModel.load(prompt: "This is a test.")
//                            }
//                        }
//                      ),
//                      secondaryButton: .cancel(
//                        Text("Cancel"),
//                        action: {
//                            isAnError.toggle()
//                        }
//                      )
//                )
//            }
//    }
//}
//
//struct LoadedView: View {
//    @EnvironmentObject var network: NetworkMonitor
//    var txtData: String?
//
//    var body: some View {
//        ScrollView {
//            Form {
//                Section {
//                    Text(verbatim: """
//                           Active: \(network.isActive)
//                           Expensive: \(network.isExpensive)
//                           Constrained: \(network.isConstrained)
//                           """)
//                        .padding()
//                }
//
//                Section {
//                    Text(txtData ?? "Nada")
//                        .font(.subheadline)
//                }
//            }
//            .padding()
//        }
//    }
//}
