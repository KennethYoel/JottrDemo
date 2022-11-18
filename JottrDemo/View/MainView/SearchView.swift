//
//  SearchView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import SwiftUI

// sub-view displays the total items in the story array
struct SearchItemCount: View {
    var totalSearched: [Story]
    
    var body: some View {
        Text("\(totalSearched.count) Items")
            .padding(.leading)
            .font(.system(.title2, design: .serif))
            .textSelection(.enabled)
    }
}

// sub-view displays the title and the list of all stories in the Core Data
struct SearchListView: View {
    @Environment(\.isSearching) var isSearching
    var searchedStoryList: [Story]

    var body: some  View {
        // if user is searching then return the total items in the array
        if isSearching {
            SearchItemCount(totalSearched: searchedStoryList)
        } else {
            Text("Recently Modified")
                .padding(.leading)
                .font(.system(.title2, design: .serif))
                .textSelection(.enabled)
        }
        
        List(searchedStoryList, id: \.self) { item in
            // for each story in the array, create a listing row
            NavigationLink(destination: ContentListDetailView(story: item, showTrashBin: .constant(false))) {
                Text(LocalizedStringKey(item.wrappedComplStory)) // requesting localization
                    .foregroundColor(.secondary)
                    .font(.system(.subheadline, design: .serif))
                    .lineLimit(3)  // limit the amount of text shown in each item in the list
            }
        }.listStyle(.inset)
    }
}

// sub-view displays SearchItemCount and a list of searched items
struct SearchableView: View {
    var searchableStory: [Story]
    var attributedResults: [AttributedString]
    
    var body: some View {
        SearchItemCount(totalSearched: searchableStory)
        
        ForEach(attributedResults, id: \.self) { result in  //provide tappable suggestions as the user types
            Text(result)
                .searchCompletion(result.convertToString)
                .font(.system(.subheadline, design: .serif))
                .lineLimit(3) // limit the amount of text shown in each item in the list
        }
    }
}

// composite view
struct SearchView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var narratives: FetchedResults<Story>
    @State private var searchQuery: String = ""
   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchListView(searchedStoryList: storyRequested)
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "All") {
                SearchableView(searchableStory: storyRequested, attributedResults: highlightedResults)
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
//                        dismissSearch()
                        dismiss()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // return the stories requested in searchable by the user
    var storyRequested: [Story] {
        get {
            var storyContents: [Story] = []
            
            if searchQuery.isEmpty {
                // append Story in Core Data to storyContents array
                storyContents.append(contentsOf: narratives)
            } else {
                let filteredStoryContent = narratives.filter {
                    /*
                     localizedCaseInsensitiveContains() lets us
                     check any part of the search strings, without
                     worrying about uppercase or lowercase characters
                     */
                   $0.wrappedComplStory.localizedCaseInsensitiveContains(searchQuery)
                }
                storyContents.append(contentsOf: filteredStoryContent)
            }
            
            return storyContents
        }
    }
    
    // returns the converted and highlighted AttributedString from String in storyRequested
    var highlightedResults: [AttributedString] {
        get {
            var attributedResults: [AttributedString] = []
            
            for item in storyRequested {
                // convert the item String to AttributedString
                debugPrint(item.wrappedComplStory.lines.count) // total number of \n lines in each story
                var attributedItem = AttributedString(item.wrappedComplStory)
                
                // assign color attribute to substring that is equal to searchQuery with case-insensitive search
                if let range = attributedItem.range(of: searchQuery, options: .caseInsensitive) {
                    attributedItem[range].backgroundColor = .blue
                    attributedItem[range].foregroundColor = .white
                }
                
                // append the attributedItem to attributedResults
                attributedResults += [attributedItem]
            }
            
            return attributedResults
        }
    }
}

extension String {
    var lines: [String] {
        self.components(separatedBy: .newlines)
    }
}
