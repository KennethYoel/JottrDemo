//
//  StoryEditorView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

struct StoryEditorView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    @Environment(\.undoManager) var undoManager
    @Environment(\.dismiss) var dismissStoryEditor
    
    @FocusState private var isInputActive: Bool

    @State private var storyEditorPlaceholder: String = "Perhap's we can begin with once upon a time..."
    @State private var isSearchViewPresented: Bool = false
    @State private var isShareViewPresented: Bool = false
    @State private var isShowingPromptEditorScreen: Bool = false
    @State private var isShowingEditorToolbar: Bool = false
    @State private var isSubmittingPromptContent: Bool = false
//    @State private var isNewStoryEditorScreen = false
//    @State var text = NSMutableAttributedString(string: "")
    
    var body: some View {
        InputView(isLoading: $txtComplVM.loading, pen: $txtComplVM.sessionStory)
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
            .disabled(txtComplVM.loading) // when loading users can't interact with this view.
    }
    
    var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            if let undoManager = undoManager {
                Button(action: undoManager.undo, label: { Label("Undo", systemImage: "arrow.uturn.backward") })
                    .disabled(!undoManager.canUndo)
                    .padding(.trailing)

                Button(action: undoManager.redo, label: { Label("Redo", systemImage: "arrow.uturn.forward") })
                    .disabled(!undoManager.canRedo)
            }
            Spacer()
            Button(action: hideKeyboardAndSave, label: { Image(systemName: "keyboard.chevron.compact.down") })
        }
    }
    
    var topLeadingToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Done", role: .destructive, action: saveResetAndDismissEditor).buttonStyle(.borderedProminent)
        }
    }
    
    var topTrailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if isInputActive {
                GenrePickerView(genreChoices: $txtComplVM.setGenre)
                    .padding()
                
                Button(action: sendToStoryCreator, label: { Image(systemName: "arrow.up.circle.fill") })
                    .buttonStyle(SendButtonStyle())
                    .padding()
            } else {
                Button(action: showPromptEditor, label: {
                    Label("Prompt Editor", systemImage: "chevron.left.forwardslash.chevron.right")
                })
                
                Menu {
                    Button(action: showPromptEditor, label: { Label("Export", systemImage: "arrow.up.doc") })
                    Button(action: presentShareView, label: { Label("Share", systemImage: "square.and.arrow.up") })
                } label: {
                     Image(systemName: "ellipsis.circle")
                }
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

    private func sendToStoryCreator() {
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
        //add a story
        let newStory = Story(context: moc)
        newStory.id = UUID()
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
