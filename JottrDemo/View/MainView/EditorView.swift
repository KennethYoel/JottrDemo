//
//  EditorView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Combine
import CoreData
import Foundation
import SwiftUI

struct EditorView: View {
    // MARK: Properties
    
    // the data managed within the ViewModel
    @StateObject var viewModel = EditorViewVM()
    // retrieve the txtcompl view model from the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.isPresented) var isPresented
    
    // dismisses this view
    @Environment(\.dismiss) var dismissNewPage
    // returns a boolean whenever user taps on the TextEditor
    @FocusState var isInputActive: Bool
    // creates a timer publisher that fires every 3 second, and then saves the managedObjectContext
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TextInputView(isLoading: $txtComplVM.loading, pen: $txtComplVM.sessionStory)
            .focused($isInputActive)
            .onAppear {
                self.txtComplVM.sessionStory = ""
            }
            .onReceive(timer) { _ in
                saveContext()
            }
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
            .fullScreenCover(isPresented: $viewModel.isShowingNewPageScreen, onDismiss: {
                dismissNewPage()
            }, content: {
                NavigationView {
                    EditorView()
                }
            })
            .alert(isPresented: $txtComplVM.failed, content: errorSubmitting)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                topLeadingToolbar
                EditorToolbar(
                    showNewPage: $viewModel.isShowingNewPageScreen.onChange(reload),
                    presentExportView: $viewModel.isShowingPromptEditorScreen,
                    presentShareView: $viewModel.isShareViewPresented,
                    showPromptEditor: $viewModel.isShowingPromptEditorScreen,
                    sendingContent: $viewModel.isSendingContent.onChange(sendToStoryMaker),
                    keyboardActive: _isInputActive
                )
                bottomToolbar
                keyboardToolbarButtons
            }
            .disabled(txtComplVM.loading) // when loading, users can't interact with this view.
    }
    
    //MARK: Toolbar Properties
    
    var topLeadingToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                Button("Done", action: saveResetAndDismissEditor)
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
    
    var keyboardToolbarButtons: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            GenrePickerView(genreChoices: $txtComplVM.setGenre)
                .padding(.trailing)
            
            Button(action: hideKeyboardAndSave, label: { Image(systemName: "keyboard.chevron.compact.down") })
        }
    }
}
