//
//  StoryListRow.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/13/22.
//

import SwiftUI

struct StoryListRow: View {
    let story: Story
    // anything with content closure we rip out that chunk of code and create a seperate view as we did here.
    var body: some View {
        NavigationLink {
            StoryListDetailView(story: story)
        } label: {
            VStack(alignment: .leading) {
                Text(story.wrappedTitle)
                    .font(.system(.headline, design: .serif))
                
                Text(story.wrappedComplStory)
                    .foregroundColor(.secondary)
                    .font(.system(.subheadline, design: .serif))
                    // limit the amount of text shown in each item in the list
                    .lineLimit(3)
                
                HStack {
                    Label("Char(s)", systemImage: "text.alignleft")
                    Text(story.formattedDate)
                        .font(.system(.caption, design: .serif))
                }
            }
        }
    }
}

//struct StoryListRow_Previews: PreviewProvider {
//    let example = PersistenceController.preview
//
//    static var previews: some View {
//        StoryListRow(story: example)
//    }
//}
