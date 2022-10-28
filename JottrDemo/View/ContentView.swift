//
//  ContentView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 9/24/22.
//
//   - a random quote page "I have been blessed with a wilder mind."

import Foundation
import SwiftUI

// defining loading state of the app
enum LoadingState {
    case notebook, storyList(Bool), storyListDetail(Story)
    
    var stringValue: String {
        switch self {
        case .notebook:
            return "notebook"
        case .storyList:
            return "storyList"
        case .storyListDetail:
            return "storyListDetail"
        }
    }
}

struct ContentView: View {
    // MARK: Properties
    
    // this view receives the NetworkMonitor object in the environment
    @EnvironmentObject var network: NetworkMonitor
    // shows an alert view if the cellular/wifi is off
    @State private var showNetworkAlert: Bool = false
    // store the default loading state
    var loadingState = LoadingState.notebook
    
    var body: some View {
        // initial view
        switch loadingState {
        case .notebook:
            NavigationView {
                NotebookView()
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
        case .storyListDetail(let story):
            StoryListDetailView(story: story)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
