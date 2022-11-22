//
//  ContentListDetailView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//
// source code for fileExporter from
// https://stackoverflow.com/questions/65993146/swiftui-2-0-export-images-with-fileexporter-modifier &
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-export-files-using-fileexporter

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ItemList: View {
    @Binding var showTrashBin: Bool
    @Binding var isLoading: Bool
    @Binding var storyContent: String
    
    var body: some View {
        if !showTrashBin {
            TextInputView(isLoading: $isLoading, pen: $storyContent)
        } else {
            VStack {
                Text(storyContent)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct ContentListDetailView: View {
    // MARK: Properties
    
    // data stored in the Core Data
    let story: Story
    @Binding var showTrashBin: Bool
    // create an object that manages the data(the logic) of ListDetailView layout
    @StateObject var viewModel = ContentListDetailVM()
    // holds our openai text completion model
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete stuff)
    @Environment(\.managedObjectContext) var moc
    // holds our dismiss action (so we can pop the view off the navigation stack)
    @Environment(\.dismiss) var dismissDetailView
    // holds boolean value on whether the txt input field is active
    @FocusState var isInputActive: Bool
    @State private var isSearchViewPresented: Bool = false
    
    var body: some View {
        ItemList(showTrashBin: $showTrashBin, isLoading: $txtComplVM.loading, storyContent: $txtComplVM.sessionStory)
            .onAppear {
                self.txtComplVM.sessionStory = story.wrappedComplStory
            }
            .onDisappear(perform: updateContext)
            .focused($isInputActive)
            .confirmationDialog("Choose a file type", isPresented: $viewModel.showingFileOptions, titleVisibility: .visible) {
                Button("Text", action: { showTextExporter(with: .plainText) })
                Button("PDF", action: { showTextExporter(with: .pdf) })
                Button("ePub", action: { showTextExporter(with: .epub) })
            }
            .fileExporter(isPresented: $viewModel.showingTextExporter, document: TextFile(initialText: self.txtComplVM.sessionStory), contentType: viewModel.givingContentType, defaultFilename: story.formattedDateCreated) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowingNewPageScreen, onDismiss: {
                dismissDetailView()
            },content: {
                NavigationView {
                    NewPageView()
                }
            })
            .sheet(isPresented: $viewModel.isShareViewPresented, onDismiss: {
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: [storyToShare()])
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                EditorToolbar(
                    showNewPage: $viewModel.isShowingNewPageScreen, // .onChange(launchNewPage)
                    presentExportView: $viewModel.showingFileOptions,
                    presentShareView: $viewModel.isShareViewPresented,
                    showPromptEditor: $viewModel.isShowingPromptEditorScreen,
                    sendingContent: $viewModel.isSendingContent.onChange(sendToContentMaker),
                    keyboardActive: _isInputActive
                )
                // toolbar defined below in a computed properties
                keyboardToolbarButtons
            }
            .disabled(txtComplVM.loading) // when loading users can't interact with this view.
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
