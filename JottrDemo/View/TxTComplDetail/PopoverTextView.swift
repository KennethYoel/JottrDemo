//
//  PopoverTextView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import SwiftUI

enum Explainer {
    case themeExplainer, premiseExplainer
}

struct PopoverTextView: View {
    
    @Binding var mainPopover: Explainer
    
    let themeExplainer: String = """
    Let's start with a theme, which is the central idea or underlying meaning you the writer and the AI explore in your
    literary work.
    
    The theme of a story can be conveyed using characters, setting, dialogue, plot, or a combination of all of these
    elements.
    
    For example in simpler stories, the theme may be a moral tale or message: “When you work hard and persevere, you can
    achieve your goals. Slow and steady wins the race.”
    
    You maybe wondering what is the difference between a genre and theme?
    
    Genre is the kind of story: Comedy, drama, romance, sci-fi, etc.

    Theme is what the story is really about.

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
    
    For every great story, bestselling novel, or Hollywood screenplay began with a premise. Story premises serve as both a hook
    for the reader and a guiding light for the writer, providing a storytelling roadmap from the first page to the last.
        
    E.g. "Three people tell conflicting versions of a meeting that changed the outcome of World War II."

    A strong premise should include ideally include three elements in a single sentence:

    1. Main character: Your story premise should include a brief description of your protagonist, such as “a teenage wizard” or
    “a grizzled detective.”
    2. Your protagonist’s goal: A solid premise will also include a simple explanation of what your main character desires or
    needs.
    3. The situation or obstacle: What crisis or extraordinary situation does your protagonist find themselves in?
    
    You may also be wondering what is the difference between a theme and premise?
    
    The theme is the underlying message behind the story. It can usually be boiled down to a couple of words that sum up what a
    plot is built around. For example it could be something like ‘family ties’, ‘overcoming adversity’ or ‘coming of age’.

    The premise is the central idea of the story: what makes it tick. Premise is the thing that your plot serves - the thing
    that define all the decisions which move your plot towards its conclusion.

    So, for example, let’s take ‘family ties’ as a theme and very broadly apply some different premises to it.

    Theme: Family Ties

    Premise: No matter how far from home you are, family is always the most important thing in life.

    Premise: Where you come from doesn’t define you.

    Premise: Blood is thicker than water.
    
    (credit: Nikita Jane Garner)
    """
    
    var body: some View {
        if mainPopover == .themeExplainer {
            Text(themeExplainer)
                .padding()
        } else if mainPopover == .premiseExplainer {
            Text(premiseExplainer)
                .padding()
        }
    }
}
