//
//  PromptEditorView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Combine
import CoreData
import SwiftUI

struct PromptEditorView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.undoManager) var undoManager
    @Environment(\.dismiss) var dismissPromptEdit
    
    @FocusState private var isInputActive: Bool

    @State private var explainerContent: Explainer = .themeExplainer
    @State private var isShowingThemePopover: Bool = false
    @State private var isShowingPremisePopover: Bool = false
    @State private var isShowingBannedPopover: Bool = false
    
    @Binding var submitPromptContent: Bool
    
//    @State private var alertUser: Bool = false
//    @State private var message: String = ""
    
//    @Binding var theme: String // = ""
//    @State private var showingStoryEditorScreen = false
    
    let themePlaceholder: String = "Type the theme here or pick one ⬇️."
    let premisePlaceholder: String = "Type the premise here..."
    let textLimit = 350
    
//    let detector = PassthroughSubject<Void, Never>()
//    let publisher: AnyPublisher<Void, Never>
    
//    init() {
//        publisher = detector
//            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
//    let banner = """
//              __,
//             (           o  /) _/_
//              `.  , , , ,  //  /
//            (___)(_(_/_(_ //_ (__
//                         /)
//                        (/
//            """
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(themePlaceholder, text: $txtComplVM.customTheme) // use onChange to update the placeholder
                        .focused($isInputActive)
                        .foregroundColor(.primary)
                        .font(.custom("Futura", size: 15)) // use either Futura, Caslon, or Johnston-the London underground typeface
                        .onReceive(Just(txtComplVM.customTheme)) { _ in limitText(textLimit) }
                    
                    ThemePickerView(themeChoices: $txtComplVM.setTheme)
                            .padding(.trailing)
                } header: {
                    HStack {
                        Text("_Theme_")
                            .font(.custom("Futura", size: 17))
                        
                        // popover with instructional information
                        Button {
                            self.explainerContent = .themeExplainer
                            isShowingThemePopover.toggle()
                            if isShowingThemePopover {
                                isShowingPremisePopover = false
                            }
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .popover(isPresented: $isShowingThemePopover) {
                            PopoverTextView(mainPopover: $explainerContent)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Section {
                    TextEditorView(title: $txtComplVM.title, text: $txtComplVM.promptLoader, placeholder: premisePlaceholder)
                        .focused($isInputActive)
                        .foregroundColor(.primary)
                        .font(.custom("Futura", size: 15))
                        .onReceive(Just(txtComplVM.sessionStory)) { _ in limitText(textLimit) }
//                        .onChange(of: txtComplVM.sessionStory) { _ in detector.send() }
//                        .onReceive(publisher) { save() }
                    
                    GenrePickerView(genreChoices: $txtComplVM.setGenre)
                        .padding(.trailing)
                } header: {
                    HStack {
                        Text("_Premise_")
                            .font(.custom("Futura", size: 17))

                        // popover with instructional information
                        Button {
                            self.explainerContent = .premiseExplainer
                            isShowingPremisePopover.toggle()
                            if isShowingPremisePopover {
                                isShowingThemePopover = false
                            }
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .popover(isPresented: $isShowingPremisePopover) {
                            PopoverTextView(mainPopover: $explainerContent)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Text("Add Prompt")
                            .font(.title)
                        
                        Spacer()
                        
                        Button(action: addPrompt, label: { Image(systemName: "plus.square.on.square").font(.title) })
                            .padding()
                            .buttonStyle(CustomButton())
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Prompt Editor")
            .toolbar {
                topPrincipleToolbar
                keyboardToolbar
            }
        }
    }
    
    var topPrincipleToolbar: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Image(systemName: "chevron.compact.down")
                .font(.title)
                .padding(.top)
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
    
    // MARK: Helper Methods
    
    private func addPrompt() {
        submitPromptContent = true
        dismissPromptEdit()
    }
    
    private func hideKeyboardAndSave() {
        isInputActive = false
        save()
   }
    
    private func save() {
        /*
         Solution: Using Combine with .debounce to publish and observe only
         after x seconds have passed with no further events.
         Must import Combine
         I have set x to 3sec.
         */
//        savedText = generationModel.primary.text
        
        print("primary sesionPrompt saved.")
    }
    
    //    // function to keep text length in limits
    private func limitText(_ upper: Int) {
        if txtComplVM.customTheme.count & txtComplVM.sessionStory.count > upper {
            txtComplVM.customTheme = String(txtComplVM.customTheme.prefix(upper))
            txtComplVM.sessionStory = String(txtComplVM.promptLoader.prefix(upper))
        }
    }
}

