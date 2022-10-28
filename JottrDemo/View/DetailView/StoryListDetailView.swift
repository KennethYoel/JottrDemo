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
    
    // data stored in the Core Data
    let story: Story
    
    @StateObject var viewModel = StoryListDetailVM()
    
    // holds our openai text completion model
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete stuff)
    @Environment(\.managedObjectContext) var moc
    // holds our dismiss action (so we can pop the view off the navigation stack)
    @Environment(\.dismiss) var dismissDetailView
    // holds our undoManager
    @Environment(\.undoManager) var undoManager
    // holds boolean value on whether the txt input field is active
    @FocusState var isInputActive: Bool
    // create an object that manages the data(the logic) of ListDetailView layout
    
    @State private var isSearchViewPresented: Bool = false

    var body: some View {
        InputView(isLoading: $txtComplVM.loading, pen: $txtComplVM.sessionStory)
            .onAppear {
                self.txtComplVM.sessionStory = story.wrappedComplStory
            }
            .focused($isInputActive)
            .fullScreenCover(isPresented: $viewModel.isShowingStoryEditorScreen, content: {
                NavigationView {
                    StoryEditorView()
                }
            })
            .sheet(isPresented: $viewModel.isShareViewPresented, onDismiss: { // this is shown when isShareViewPresented is true
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: [storyToShare()]) //[URL(string: "https://www.swifttom.com")!]
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                keyboardToolbar
                storyListDetailToolbar
                // newStoryEditorScreen: $isNewStoryEditorScreen.onChange(save),
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
}
