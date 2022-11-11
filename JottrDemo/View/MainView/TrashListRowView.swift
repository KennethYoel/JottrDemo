//
//  TrashListRowView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/11/22.
//

import Foundation
import SwiftUI

// sub-view of the composite view StoryListView, the content closure of ForEach
struct TrashListRowView: View {
    let trash: TrashBin
    
    var body: some View {
        NavigationLink {
            TrashListDetailView(trash: trash)
        } label: {
            VStack(alignment: .leading) {
                Text(trash.origin?.wrappedComplStory ?? "Unknown")
                    .listRowStyle()
                
                HStack {
                    Label("Char(s)", systemImage: "text.alignleft")
                        .captionStyle()
                    Text(trash.origin?.formattedDate ?? "N/A")
                        .captionStyle()
                }
            }
        }
    }
}
