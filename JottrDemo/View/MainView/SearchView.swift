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
    @Binding var category: String

    var body: some  View {
        // if user is searching then return the total items in the array
        if isSearching {
            SearchItemCount(totalSearched: searchedStoryList)
        } else {
            Text(category)
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
        }
        .listStyle(.inset)
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

// composite search view
struct SearchView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var stories: FetchedResults<Story>
    @State private var searchQuery: String = ""
    @State private var defaultCategory: String = "All"
    var category: [String] = ["All", "Recent", "Trash"]
   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // gives the user the option to search in either all content, most recent, or trash bin
                Picker("Choose A Category", selection: $defaultCategory) {
                    ForEach(category, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                SearchListView(searchedStoryList: contentRequested, category: $defaultCategory)
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search") {
                SearchableView(searchableStory: contentRequested, attributedResults: highlightedResults)
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // return the stories requested in searchable by the user
    var contentRequested: [Story] {
        get {
            var fetchedStories: [Story] = []
            
            let contentList: String = defaultCategory
            switch contentList {
            case "All":
                // filter returns all contents that hasn't been discarded
                let unDiscardedContent = stories.filter {
                    return !$0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: unDiscardedContent)
            case "Recent":
                // filter returns content that hasn't been discarded from the last seven days.
                let sortedByDate = stories.filter {
                    guard let unwrappedValue = $0.dateCreated else {
                        return false
                    } // 604800 sec. is about seven days in seconds
                    return unwrappedValue > (Date.now - 604_800) && !$0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: sortedByDate)
            case "Trash":
                // filter return content that has been discarded
                let discardedContent = stories.filter {
                    return $0.wrappedIsDiscarded
                }
                fetchedStories.append(contentsOf: discardedContent)
            default:
                // if all else fail return an empty array
                return [] // TODO: maybe return an error message
            }
            
            return fetchedStories
        }
    }
    
    // returns the converted and highlighted AttributedString from String in storyRequested
    var highlightedResults: [AttributedString] {
        get {
            var attributedResults: [AttributedString] = []
            
            for item in contentRequested {
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
