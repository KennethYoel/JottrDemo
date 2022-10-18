//
//  StoryListDetailView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import SwiftUI

struct StoryListDetailView: View {
    // MARK: Properties
    
    let story: Story
    // create an object that manages the data(the logic) of ListDetailView layout
    @StateObject var viewModel = ViewModel()
    // holds our openai text completion model
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete stuff)
    @Environment(\.managedObjectContext) var moc
    // holds our dismiss action (so we can pop the view off the navigation stack)
    @Environment(\.dismiss) var dismissDetailView
    // holds our undoManager
    @Environment(\.undoManager) var undoManager
    // holds boolean value on whether the txt input field is active
    @FocusState private var isInputActive: Bool
   
    @State private var isShowingStoryEditorScreen: Bool = false
    @State private var isShowingPromptEditorScreen: Bool = false
    @State private var isShowingEditorToolbar: Bool = false
    @State private var isShareViewPresented: Bool = false
    // control whether we’re showing the delete confirmation alert or not
    @State private var showingDeleteAlert = false
    
    var body: some View {
        TextEditorView(title: $txtComplVM.title, text: $txtComplVM.sessionStory, placeholder: "")
            .onAppear {
                self.txtComplVM.title = story.wrappedTitle
                self.txtComplVM.sessionStory = story.wrappedComplStory
            }
            .focused($isInputActive)
            .padding([.leading, .top, .trailing,])
            .fullScreenCover(isPresented: $isShowingStoryEditorScreen, content: {
                NavigationView {
                    StoryEditorView()
                }
            })
            .sheet(isPresented: $isShareViewPresented, onDismiss: { // this is shown when isShareViewPresented is true
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: ["The Story"]) //[URL(string: "https://www.swifttom.com")!]
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                keyboardToolbar
                storyListDetailToolbar
                // newStoryEditorScreen: $isNewStoryEditorScreen.onChange(save),
            }
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
    
    var storyListDetailToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if isInputActive {
                Button(action: sendToStoryCreator, label: { Image(systemName: "arrow.up.circle.fill") })
                    .buttonStyle(SendButtonStyle())
                    .padding()
            } else {
                Button(action: launchNewPage, label: { Label("New Story", systemImage: "square.and.pencil") })
                
                Menu {
                    Button(action: exportToFile, label: { Label("Export", systemImage: "arrow.up.doc") })
                    Button(action: presentShareView, label: { Label("Share", systemImage: "square.and.arrow.up") })
                } label: {
                     Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
    // MARK: Helper Methods
    
    private func hideKeyboardAndSave() {
        isInputActive = false
        updateContext()
    }
    
    private func sendToStoryCreator() {
        Task {
            await txtComplVM.generateStory()
        }
        updateContext()
    }
    
    private func launchNewPage() {
        updateContext()
        txtComplVM.title = ""
        txtComplVM.sessionStory = ""
        dismissDetailView()
        isShowingStoryEditorScreen.toggle()
    }
    
    private func exportToFile() {
        
    }
    
    private func presentShareView() {
        isShareViewPresented.toggle()
    }
    
    private func updateContext() {
        //update the saved story
        moc.performAndWait {
            story.title = self.txtComplVM.title
            story.complStory = self.txtComplVM.sessionStory
            
            PersistenceController.shared.saveContext()
        }
    }
    
    private func deleteBook() {
        // delete from in memory storage
        moc.delete(story)
        
        // write the changes out to persistent storage
        PersistenceController.shared.saveContext()
        
        // hide current view
        dismissDetailView()
    }
}
