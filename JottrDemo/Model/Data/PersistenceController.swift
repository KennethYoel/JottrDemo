//
//  PersistenceController.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import CoreData
import Foundation

class PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    
    // storage for Core Data
    let container: NSPersistentContainer
    
    // a test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: false)
        
        // create a example story
        let story = Story(context: controller.container.viewContext)
        story.id = UUID()
        story.genre = "Horror"
        story.theme = "Redemption"
        story.sessionPrompt = "Test Prompt"
        story.complStory = "Test Story"
        
        return controller
    }()
    
    /*
     an initializer to load CoreData, optionally able to use an in-memory store to save information
     into memory rather than disk. All the changes you make will be thrown away when your program ends.
     */
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "JottrDemo")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        /*
         This asks Core Data to merge duplicate objects based on their properties – it tries to intelligently overwrite the
         version in its database using properties from the new version. When you Save the data, Core Data strips out
         all the duplicates.
         */
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func saveContext() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
}

