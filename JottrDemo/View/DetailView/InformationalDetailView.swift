//
//  InformationalDetailView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 12/2/22.
//

import SwiftUI

struct InformationalDetailView: View {
    let markdownIntroText: [LocalizedStringKey] = ["""
*Overview*
Jottr's interface has three main views you should get familiar with:

- Collection
- Page List
- Editor

The **collection** allows access to your texts and it is divided into sections. Such as **entirety** the name says it all, **recent** which contains your written work from the past seven days, and **trash** where any deleted content will be held for thirty days which at that point it wiil be permanently deleted.

The *collection list* is where all your and the AI co-writer written texts lives.

And the *editor* where all the magic happens. Simply write and your AI co-writer will complete your texts.
""", """
*Basic Navigation*
To switch between the three main views simply tap on the links, and to go back use the navigation bar or tap done.
""", """
*Pages*
All generated content is done on Jottr custom text editor I like to call *pages*. Pages are similar to Notes, in that a title or a file name isn't required and the pages are saved automatically. Pages can hold any amount of text.
You request pages via the navigation bar *New Page* 􀈎 button found in the collection/page list or in the editor.
""", """
*Editor*
You'll arrive at the *editor* by either tapping *New Page* 􀈎 button on the navigation bar or tap one of the *pages* in the *page list* where you can edit your work.

Once there, at the bottom right is the *Genre* picker where you can set the genre of the story and on top from the right, if the iPhone's virtual keyboard is active, you'll see the *New Page* 􀈎, *Menu* 􀍡, and a *Submit* 􀄨 button. The *Submit* button is hidden when the virtual keyboard becomes inactive. When active the virtual keyboard will have a button row sitting directly above it. Far right there's the dismiss keyboard icon and next to that is the *Genre* picker again.

Back to the navigation bar above you can tap the *Menu* 􀍡 button to access the *Export*, *Share*, and *Prompt Editor* options. *Export* gives you the option to save the text to your device either as plain text, pdf, or epub. With *Share* you can well share with your peers the current text shown in the editor. And the *Prompt Editor* allows you the write the backstory, set the theme, premise, and the genre of the story which all of it get's concatenate and sent to OpenAI API as a prompt parameter, and there's a link to more advance setting where you can adjust other AI parameters. When you have completed your set up tap on 􀃜 *Add Prompt* button to submit it to OpenAI API and then shortly you should be receiving back a generated story for your reading pleasure.
""", """
*Account Settings*
You'll find the settings via the navigation bar *Account Settings* 􀍟 button.
From the top you can *Login* into your account where your username will be used as a unique identifier, which can help OpenAI to monitor and detect abuse and save other account settings.
The *Contact Support* link will allow to send me an email for any support or question the user may have.
Next up, *Leave Feedback*(work in progress) should open up a store review alert view so the user can leave an app review in the app store.
After that is the *AI Settings* allowing you to adjust the AI parameters which the values set will be stored in the app in a persistent state.
And at the end is the *Logout* link, tap it to logout of your account.
""", """
*Search View*
The *Search* view can be found in the *Collection* and *Page List* view, at the bottom right there's an search icon button that you can tap and from there you can search each section found in *collection*; entirety, recent, and trash. Tap on your find and that will lead you to the *editor*.

"""]
    
    var body: some View {
        List {
            ForEach(markdownIntroText.indices, id: \.self) { index in
                NavigationLink {
                    ScrollView {
                        Text(markdownIntroText[index])
                            .padding()
                            .font(.system(.body, design: .serif))
                            .lineSpacing(5)
                            .multilineTextAlignment(.leading)
                    }
                } label: {
                    Text(markdownIntroText[index])
                            .listRowStyle()
                }
            }
        }
        .navigationTitle("Info")
    }
}

struct InformationalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InformationalDetailView()
    }
}
