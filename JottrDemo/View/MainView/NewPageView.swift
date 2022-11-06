//
//  StoryEditorView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import CoreData
import Foundation
import SwiftUI

struct NewPageView: View {
    // MARK: Properties
    
    // retrieve the txtcompl view model from the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    // dismiss this view
    @Environment(\.dismiss) var dismissStoryEditor
    // returns a boolean whenever user taps on the TextEditor
    @FocusState var isInputActive: Bool
    
    @State private var storyEditorPlaceholder: String = "Perhap's we can begin with once upon a time..."
    @State private var isSearchViewPresented: Bool = false
    @State private var isShareViewPresented: Bool = false
    @State private var isShowingPromptEditorScreen: Bool = false
    @State private var isShowingEditorToolbar: Bool = false
    @State private var isSubmittingPromptContent: Bool = false
    @State private var isKeyboardActive: Bool = false
    @State private var id: UUID = UUID()
    var idInStoryList: String = ""
    // i need the id of the story in the list
    
    var body: some View {
        TextInputView(isLoading: $txtComplVM.loading, pen: $txtComplVM.sessionStory)
            .focused($isInputActive)
            .sheet(isPresented: $isShowingPromptEditorScreen, onDismiss: {
                promptContent()
            }, content: {
                PromptEditorView(submitPromptContent: $isSubmittingPromptContent)
            })
            // the sheet below is shown when isShareViewPresented is true
            .sheet(isPresented: $isShareViewPresented, onDismiss: {
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: [txtComplVM.sessionStory]) //[URL(string: "https://www.swifttom.com")!]
            })
            .alert(isPresented: $txtComplVM.failed, content: errorSubmitting)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                keyboardToolbar
                topLeadingToolbar
                topTrailingToolbar
                bottomToolbar
            }
            .disabled(txtComplVM.loading) // when loading, users can't interact with this view.
    }
    
    var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            GenrePickerView(genreChoices: $txtComplVM.setGenre)
                .padding(.trailing)
            Button(action: hideKeyboardAndSave, label: { Image(systemName: "keyboard.chevron.compact.down") })
        }
    }
    
    var topLeadingToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                Button("Done", action: saveResetAndDismissEditor)
                    .buttonStyle(.plain)
            }
        }
    }
    
    var topTrailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            Button(action: launchNewPage, label: {  Label("New Story", systemImage: "square.and.pencil") })
            
            Menu {
                // present the ExportView
                Button(action: {  isShowingPromptEditorScreen.toggle() }, label: { Label("Export", systemImage: "arrow.up.doc") })
                // present the UIShareView
                Button(action: { isShareViewPresented.toggle() }, label: { Label("Share", systemImage: "square.and.arrow.up") })
                // routes user to the PromptEditorView
                Button(action: {  isShowingPromptEditorScreen.toggle() }, label: {
                    Label("Prompt Editor", systemImage: "chevron.left.forwardslash.chevron.right")
                })
            } label: {
                 Image(systemName: "ellipsis.circle")
            }
            .foregroundColor(.black)
            
            if isInputActive {
                Button(action: sendToStoryMaker, label: { Image(systemName: "arrow.up") })
                    .padding([.leading, .trailing])
                    .buttonStyle(.plain)
            }
        }
    }
    
    var bottomToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            if !isInputActive {
                Spacer()
                GenrePickerView(genreChoices: $txtComplVM.setGenre).padding()
            }
        }
    }
    
    // MARK: Helper Methods
    
    private func promptContent() {
        if isSubmittingPromptContent {
            Task {
                await txtComplVM.generateStory()
            }
        } else {
            txtComplVM.promptLoader = ""
            txtComplVM.setTheme = .custom
        }
    }
    
    private func errorSubmitting() -> Alert {
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

    private func sendToStoryMaker() {
        Task {
            await txtComplVM.generateStory()
        }
    }
    
    private func showPromptEditor() {
        isShowingPromptEditorScreen.toggle()
    }
    
    private func presentShareView() {
        isShareViewPresented.toggle()
    }
    
    private func hideKeyboardAndSave() {
        isInputActive = false
        save()
    }
    
    private func saveResetAndDismissEditor() {
        save()
        txtComplVM.sessionStory = ""
        dismissStoryEditor()
    }
    
    private func save() {
        let newStory: Story!
        
        let fetchStory: NSFetchRequest<Story> = Story.fetchRequest()
        
        if idInStoryList.isEmpty {
            fetchStory.predicate = NSPredicate(format: "id = %@", id.uuidString) // create a UUID as a string
        } else {
            fetchStory.predicate = NSPredicate(format: "id = %@", idInStoryList)
            debugPrint(idInStoryList)
        }
        
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
        
        if !txtComplVM.sessionStory.isEmpty {
            //add a story
            newStory.id = id
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
