//
//  StoryListRow.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/13/22.
//

import Foundation
import SwiftUI

// sub-view of the composite view StoryListView, the content closure of ForEach
struct StoryListRowView: View {
    let story: Story
    
    var body: some View {
        NavigationLink {
            ContentView(loadingState: .storyListDetail(story))
        } label: {
            VStack(alignment: .leading) {
                Text(story.wrappedComplStory)
                    .listRowStyle()
                
                HStack {
                    Label("Char(s) \(story.wrappedComplStory.count)", systemImage: "text.alignleft")
                        .captionStyle()
                    Text(story.formattedDate)
                        .captionStyle()
                }
            }
        }
    }
}
