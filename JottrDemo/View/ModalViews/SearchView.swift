//
//  SearchView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import SwiftUI

struct SearchView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)]) var workOfFiction: FetchedResults<Story>
    @State private var searchQuery: String = ""
    @State private var searching: Bool = false
   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Recently Modified")
                    .padding(.leading)
                    .font(.system(.title2, design: .serif))
                    .textSelection(.enabled)
                
                List(searchResults, id: \.self) { item in
                    NavigationLink(destination: Text(item)) {
                        Text(LocalizedStringKey(item)) // requesting localization
                            .foregroundColor(.secondary)
                            .font(.system(.subheadline, design: .serif))
                            .lineLimit(3)  // limit the amount of text shown in each item in the list
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "All") {
                VStack(alignment: .leading) {
                    Text("\(searchResults.count) Items")
                        .font(.system(.title2, design: .serif))
                        .textSelection(.enabled)
                    
                    //provide tappable suggestions as the user types
                    ForEach(highlightedResults, id: \.self) { result in
                        NavigationLink(destination: Text(result)) {
                            Text(result)
                                .font(.system(.subheadline, design: .serif))
                                .lineLimit(3) // limit the amount of text shown in each item in the list
                        }
                    }
                }
            }
            .onSubmit(of: .search) {
//                viewModel.submitCurrentSearchQuery()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismissSearch()
                        dismiss()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
//        .onChange(of: searchQuery) { _ in highlightText() }
    }
    
    var searchResults: [String] {
        get {
            var stories: [String] = []
            
            if searchQuery.isEmpty {
                for eachStory in workOfFiction {
                    if let unwrappedStory = eachStory.complStory {
                        stories += [unwrappedStory]
                    }
                }
                return stories
            } else {
                /*
                 localizedCaseInsensitiveContains()
                 lets us check any part of the search strings, without worrying about
                 uppercase or lowercase letters
                 */
                for tale in workOfFiction {
                    if let unwrappedStory = tale.complStory {
                        stories += [unwrappedStory]
                    }
                }
                // may need to put the code back to what it was and convert it after in highlightText()
                return stories.filter { $0.localizedCaseInsensitiveContains(searchQuery) }
            }
        }
    }
    
    var highlightedResults: [AttributedString] {
        get {
            var attributedResults: [AttributedString] = [AttributedString()]
            var attributedItem: AttributedString!
            
            for item in searchResults {
                // convert the item String to AttributedString
                attributedItem = AttributedString(item)
                
                // assign color attribute to substring that is equal to searchQuery using case-insensitive search
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
