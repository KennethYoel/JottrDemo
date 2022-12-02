//
//  PopoverTextView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import SwiftUI

enum Explainer {
    case themeExplainer, premiseExplainer, aiParameterExplainer
}

struct PopoverTextView: View {
    
    @Binding var mainPopover: Explainer
    
    let themeExplainer: String = """
    Let's start with a theme, which is the central idea or underlying meaning you as the writer and your co-writer AI explore in your literary work.
    
    The theme of a story can be conveyed using characters, setting, dialogue, plot, or a combination of all of these elements.
    For example in simpler stories, the theme may be a moral tale or message: “When you work hard and persevere, you can achieve your goals. Slow and steady wins the race.”
    
    You maybe wondering what is the difference between a genre and theme?
    >Genre is the kind of story: Comedy, drama, romance, sci-fi, etc.
    >Theme is what the story is really about.

    E.g.
    Lawrence of Arabia (1962)
    Genre: Historical drama
    Theme: Who am I?
    
    Ex Machina (2015)
    Genre: Science fiction
    Theme: What is it to be human?
    """
    
    let premiseExplainer = """
    Here we have the premise, which is your entire story condensed to a single sentence.
    
    For every great story, bestselling novel, or Hollywood screenplay began with a premise. Story premises serve as both a hook for the reader and a guiding light for the writer, providing a storytelling roadmap from the first page to the last.
        
    E.g. "Three people tell conflicting versions of a meeting that changed the outcome of World War II."

    A strong premise should include ideally include three elements in a single sentence:

    >Main character: Your story premise should include a brief description of your protagonist, such as “a diminutive wizard” or “a grizzled detective.”
    >Your protagonist’s goal: A solid premise will also include a simple explanation of what your main character desires or needs.
    >The situation or obstacle: What crisis or extraordinary situation does your protagonist find themselves in?
    """
    
    let aiParameterExplainer = """
    Response Length - Affects the max amount of characters the AI will return.
    The GPT family of models process text using tokens, which are common sequences of characters found in text. A rule of thumb is that one token generally corresponds to ~4 characters of text for common English text. This translates to roughly ¾ of a word (so 100 tokens ~= 75 words).
    See https://beta.openai.com/docs/models/gpt-3
    
    Temperature - Affects the randomness of the AI. Higher values mean more randomness.
    
    Top P - An alternative to sampling with temperature. Affects the randomness of the AI. Higher values mean more randomness. We generally recommend altering this or temperature but not both.
    
    Appearance Penalty - Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    
    Repetition Penalty - Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    """
    
    var body: some View {
        NavigationView {
            Text(popoverText)
                .font(.system(.caption, design: .serif))
                .multilineTextAlignment(.leading)
                .textSelection(.enabled)
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    topPrincipleToolbar
                }
        }
    }
    
    var popoverText: String {
        get {
            var explainerValue: String = ""
            
            if mainPopover == .themeExplainer {
                explainerValue = themeExplainer
            } else if mainPopover == .premiseExplainer {
                explainerValue = premiseExplainer
            } else {
                explainerValue = aiParameterExplainer
            }
            
            return explainerValue
        }
    }
    
    var topPrincipleToolbar: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Image(systemName: "chevron.compact.down")
                .font(.largeTitle)
                .padding(.top)
        }
    }
}
