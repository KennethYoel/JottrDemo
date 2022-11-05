//
//  HandlingLoadingStateApp.swift
//  HandlingLoadingState
//
//  Created by Kenneth Gutierrez on 9/24/22.
//
// Abstract: The main app, which creates a scene that contains a window group, displaying the root content view.

import Foundation
import SwiftUI

@main
struct JottrDemoApp: App {
    // MARK: Properties
    
    // environment key that automatically updated as the app moves between the foreground, background, and inactive states 
    @Environment(\.scenePhase) var scenePhase
    // create an instance of NetworkMonitor then inject it into the SwiftUI environment
    let monitor = NetworkMonitor()
    // give the app struct a property to store the persistence controller
    let persistenceController = PersistenceController.shared
    // create an instance of TxtComplViewModel then inject it into the SwiftUI environment
    @StateObject var txtComplVM = TxtComplViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(monitor)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(txtComplVM)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.saveContext()
        }
    }
}
