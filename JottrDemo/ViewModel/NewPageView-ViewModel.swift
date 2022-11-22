//
//  NewPageView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/6/22.
//

import CoreData
import Foundation
import SwiftUI

extension NewPageView {
    // MARK: Manages The Data(the logic)
    
    @MainActor class NewPageViewVM: ObservableObject {
        // MARK: Properties
        
        @Published var isSearchViewPresented: Bool = false
        @Published var isShareViewPresented: Bool = false
        @Published var isShowingPromptEditorScreen: Bool = false
        @Published var isShowingNewPageScreen: Bool = false
        @Published var isSubmittingPromptContent: Bool = false
        @Published var isSendingContent: Bool = false
        @Published var isClosingView: Bool = false
        @Published var isKeyboardActive: Bool = false
        @Published var id: UUID = UUID()
    }
    
    // MARK: Helper Methods
    
    func hideKeyboardAndSave() {
        isInputActive = false
        saveContext()
    }
    
    func promptContent() {
        if viewModel.isSubmittingPromptContent {
            Task {
                await txtComplVM.generateStory()
            }
        } else {
            txtComplVM.promptLoader = ""
            txtComplVM.setTheme = .custom
        }
    }
    
    func errorSubmitting() -> Alert {
        Alert(title: Text(""),
              message: Text("\(txtComplVM.errorMessage)"),
              primaryButton: .default(Text("Try Again"), action: {
                    Task {
                        await txtComplVM.generateStory()
                    }
                }
              ),
              secondaryButton: .cancel(Text("Cancel"), action: {
                    txtComplVM.failed.toggle()
                }
              )
        )
    }

    func sendToStoryMaker(_ value: Bool) {
        if value {
            Task {
                await txtComplVM.generateStory()
            }
        }
    }
    
    func reload(_ value: Bool) {
        if value {
            saveContext()
            txtComplVM.sessionStory = ""
            viewModel.id = UUID()
        }
    }
    
    func saveResetAndDismissEditor() {
        saveContext()
        txtComplVM.sessionStory = ""
        dismissNewPage()
    }
    
    func saveContext() {
        debugPrint("saved")
        
        if !txtComplVM.sessionStory.isEmpty {
            let saveStory: Story!
            
            let fetchStory: NSFetchRequest<Story> = Story.fetchRequest()
            fetchStory.predicate = NSPredicate(format: "id = %@", viewModel.id.uuidString) // create's a UUID as a string
            
            var results: [Story]!
            do {
                results = try moc.fetch(fetchStory)
            } catch {
                print(error.localizedDescription)
            }
            
            if results.count == 0 {
                // here you are inserting
                saveStory = Story(context: moc)
             } else {
                // here you are updating
                 saveStory = results.first
             }
        
            //add a story
            saveStory.complStory = txtComplVM.sessionStory
            saveStory.dateCreated = Date()
            saveStory.genre = txtComplVM.setGenre.id
            saveStory.id = viewModel.id
            saveStory.isDiscarded = false
            saveStory.sessionPrompt = txtComplVM.promptLoader

            if txtComplVM.setTheme.id == "Custom" {
                saveStory.theme = txtComplVM.customTheme
            } else {
                saveStory.theme = txtComplVM.setTheme.id
            }

            PersistenceController.shared.saveContext()
        }
    }
}
