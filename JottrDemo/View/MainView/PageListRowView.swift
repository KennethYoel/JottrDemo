//
//  PageListRow.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/13/22.
//

import Foundation
import SwiftUI

// sub-view of the composite view StoryListView, the content closure of ForEach
struct PageListRowView: View {
    let story: Story
    @Binding var showTrashBin: Bool
    
    var body: some View {
        NavigationLink {
            PageListDetailView(story: story, showTrashBin: $showTrashBin)
        } label: {
            VStack(alignment: .leading) {
                Text(story.wrappedComplStory)
                    .listRowStyle()
                
                HStack {
                    Label("Char(s) \(story.wrappedComplStory.count)", systemImage: "text.alignleft")
                        .captionStyle()
                    Text(story.formattedDateCreated)
                        .captionStyle()
                }
            }
        }
    }
}
