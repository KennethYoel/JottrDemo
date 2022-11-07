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
    
    func hideKeyboardAndSave() {
        isInputActive = false
        save()
    }
    
    func reload(_ value: Bool) {
        if value {
            save()
            txtComplVM.sessionStory = ""
            viewModel.id = UUID()
        }
    }
    
    func saveResetAndDismissEditor() {
        save()
        txtComplVM.sessionStory = ""
        dismissNewPage()
    }
    
    func save() {
        if !txtComplVM.sessionStory.isEmpty {
            let newStory: Story!
            
            let fetchStory: NSFetchRequest<Story> = Story.fetchRequest()
            fetchStory.predicate = NSPredicate(format: "id = %@", viewModel.id.uuidString) // create a UUID as a string
            
            var results: [Story]!
            do {
                results = try moc.fetch(fetchStory)
            } catch {
                print(error.localizedDescription)
            }
            
            if results.count == 0 {
                // here you are inserting
                newStory = Story(context: moc)
             } else {
                // here you are updating
                 newStory = results.first
             }
        
            //add a story
            newStory.id = viewModel.id
            newStory.creationDate = Date()
            newStory.genre = txtComplVM.setGenre.id
            newStory.sessionPrompt = txtComplVM.promptLoader
            newStory.complStory = txtComplVM.sessionStory

            if txtComplVM.setTheme.id == "Custom" {
                newStory.theme = txtComplVM.customTheme
            } else {
                newStory.theme = txtComplVM.setTheme.id
            }

            PersistenceController.shared.saveContext()
        }
    }
}
