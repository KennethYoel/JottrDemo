//
//  PromptEditorView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Combine
import CoreData
import Foundation
import SwiftUI

struct PromptEditorView: View {
    // MARK: Properties
    
    // constants used in this view
    let themePlaceholder: String = "Type the theme here or pick one ⬇️."
    let premisePlaceholder: String = "Type the premise here..."
    let textLimit = 350
    // retrieve the txtcompl view model from the environment
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // dismiss this view
    @Environment(\.dismiss) var dismissPromptEdit
    // returns a boolean whenever user taps on the TextEditor
    @FocusState var isInputActive: Bool
    // retrieve the prompt editor view model where the data is managed
    @StateObject var viewModel = PromptEditorViewVM()
    // a binded boolean variable 
    @Binding var submitPromptContent: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(themePlaceholder, text: $txtComplVM.customTheme)
                        .focused($isInputActive)
                        .foregroundColor(.primary)
                        .font(.system(.body, design: .serif))
                        .onReceive(Just(txtComplVM.customTheme)) { _ in limitText(textLimit) }
                    
                    // user can choose a theme here from a list of enums or type one above in TextField
                    ThemePickerView(themeChoices: $txtComplVM.setTheme)
                            .padding(.trailing)
                } header: {
                    HStack {
                        Text("_Theme_")
                            .font(.system(.subheadline, design: .serif))
                        
                        // popover with instructional information
                        Button(action: { viewModel.showThemePopover() }, label: {
                            Image(systemName: "questionmark.circle")
                        })
                        .popover(isPresented: $viewModel.isShowingThemePopover) {
                            PopoverTextView(mainPopover: $viewModel.explainerContent)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Section {
                    // here a user can define the prompt paramater for the OpenAI API
                    TextEditorView(text: $txtComplVM.promptLoader, placeholder: premisePlaceholder)
                        .focused($isInputActive)
                        .foregroundColor(.primary)
                        .font(.system(.body, design: .serif))
                        .onReceive(Just(txtComplVM.sessionStory)) { _ in limitText(textLimit) }
                    
                    // user can choose a theme here from a list of enum
                    GenrePickerView(genreChoices: $txtComplVM.setGenre)
                        .padding(.trailing)
                } header: {
                    HStack {
                        Text("_Premise_")
                            .font(.system(.subheadline, design: .serif))

                        // popover with instructional information
                        Button(action: { viewModel.showPremisePopover() }, label: {
                            Image(systemName: "questionmark.circle")
                        })
                            .popover(isPresented: $viewModel.isShowingPremisePopover) {
                                PopoverTextView(mainPopover: $viewModel.explainerContent)
                            }
                    }
                }
                
                Section {
                    // a link to other OpenAI API advanced parameters that a user can adjust
                    NavigationLink("Advance Settings", destination: AccountDetailView())
                }
                
                Section {
                    HStack {
                        Spacer()
                        // adds prompt parameter and request for text completion to OpenAI API
                        Button(action: addPrompt, label: { Label("Add Prompt", systemImage: "plus.square") })
                            .buttonStyle(FormControlButton())
                            .padding()
                        Spacer()
                    }
                }
            }
            .navigationTitle("Prompt Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // top trailing dismiss button
                DoneButton(isDismiss: $viewModel.isDismiss.onChange { _ in
                    dismissPromptEdit()
                })
                
                // keyboard bar dismiss button
                keyboardToolbar
            }
        }
    }
    
    var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            // dismisses keyboard
            Button(action: { isInputActive.toggle() }, label: {
                Image(systemName: "keyboard.chevron.compact.down")
            })
        }
    }
}

