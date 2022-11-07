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
    // the data managed within the ViewModel
    @StateObject var viewModel = NewPageViewVM()
    
    var body: some View {
        TextInputView(isLoading: $txtComplVM.loading, pen: $txtComplVM.sessionStory)
            .focused($isInputActive)
            .sheet(isPresented: $viewModel.isShowingPromptEditorScreen, onDismiss: {
                promptContent()
            }, content: {
                PromptEditorView(submitPromptContent: $viewModel.isSubmittingPromptContent)
            })
            // the sheet below is shown when isShareViewPresented is true
            .sheet(isPresented: $viewModel.isShareViewPresented, onDismiss: {
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: [txtComplVM.sessionStory]) //[URL(string: "https://www.swifttom.com")!]
            })
            .fullScreenCover(isPresented: $viewModel.isShowingStoryEditorScreen, onDismiss: {
//                isStoryListActive.toggle()
            }, content: {
                NavigationView {
                    NewPageView()
                }
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
            Button(action: { reload() }, label: {
                Label("New Story", systemImage: "square.and.pencil")
            })
            
            Menu {
                // present the ExportView
                Button(action: {  viewModel.isShowingPromptEditorScreen.toggle() }, label: { Label("Export", systemImage: "arrow.up.doc") })
                // present the UIShareView
                Button(action: { viewModel.isShareViewPresented.toggle() }, label: { Label("Share", systemImage: "square.and.arrow.up") })
                
                Divider()
                
                // routes user to the PromptEditorView
                Button(action: {  viewModel.isShowingPromptEditorScreen.toggle() }, label: {
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
    
    func launchNewPage() { // this part ist kaput, need an alternative to creating a new page, how to update UUID
        saveResetAndDismissEditor()
        viewModel.isShowingStoryEditorScreen.toggle()
    }
    
    private func promptContent() {
        if viewModel.isSubmittingPromptContent {
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
        viewModel.isShowingPromptEditorScreen.toggle()
    }
    
    private func presentShareView() {
        viewModel.isShareViewPresented.toggle()
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
