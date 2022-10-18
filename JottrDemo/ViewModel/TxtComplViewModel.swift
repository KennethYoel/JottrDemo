//
//  TxtComplViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 9/24/22.
//

import Foundation
import SwiftUI

@MainActor class TxtComplViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var promptLoader: String = ""
    @Published var sessionStory: String = "" //[SessionStory] = [SessionStory]()
    @Published var setTheme: CommonTheme = .custom
    @Published var customTheme: String = ""
    @Published var setGenre: CommonGenre = .fantasy
    @Published var loading: Bool = false
    @Published var failed: Bool = false
    @Published var errorMessage: String = ""
//    @Published private(set) var state = State.idle
    
//    var primary: SessionStory {
//        get {
//            if sessionStory.isEmpty {
//                return SessionStory.init(id: UUID(), text: "")
//            }
//            return sessionStory[0]
//        }
//        set(newStory) {
//            sessionStory = [newStory]
//        }
//    }
    
    func generateStory() async {
        var theTheme = ""
        if setTheme.id == "Custom" {
            theTheme = customTheme
        } else {
            theTheme = setTheme.id
        }
        
        var promptText: String = ""
        if sessionStory.isEmpty {
            promptText = promptLoader
        } else {
            promptText = sessionStory
        }
        
        let textResults = promptDesign(theTheme, promptText)
        await getTextResponse(moderated: false, sessionStory: textResults)
    }
    
    func promptDesign(_ mainTheme: String = "", _ storyPrompt: String) -> String {
        let theGenre: String = setGenre.id
        
        let prompt = """
        Topic: Breakfast
        Two-Sentence Horror Story: He always stops crying when I pour the milk on his cereal. I just have to remember not to
        let him see his face on the carton.
        
        Topic: \(mainTheme)
        Seventy-Sentence \(theGenre) Story: \(storyPrompt)
        """
        
        return prompt
    }
    
    func getTextResponse(moderated: Bool, sessionStory: String) async {
        loading.toggle()
    
        do {
            try await handleResponse(withModeration: moderated, textForPrompt: sessionStory)
        } catch let error as CustomError {
            loading.toggle()
            failed.toggle()
            switch error {
            case .failCodableResponse:
                errorMessage = CustomError.failCodableResponse.stringValue()
            default:
                errorMessage = error.localizedDescription
                break
            }
        } catch {
            debugPrint(error)
        }
    }
    
    // handles the return data from OpenAI API
    func handleResponse(withModeration: Bool, textForPrompt: String) async throws {
        let openaiResponse = await OpenAIConnector.loadText(with: withModeration, sessionPrompt: textForPrompt)
        
        guard let data = openaiResponse else {
            throw CustomError.failCodableResponse
        }
        let newText = data.choices[0].completionText
        self.appendToStory(sessionStory: newText)
        loading.toggle()
        //        DispatchQueue.main.async {
        //            self.state = .loaded(completedText) no longer need DispatchQueue weil using MainActor
        //        }
    }
    
    func appendToStory(sessionStory: String) {
        if self.sessionStory.isEmpty {
            // concatenate the next part of the generated story onto the existing story
            self.sessionStory += promptLoader + sessionStory
        } else {
            self.sessionStory += sessionStory
        }
    }
}
