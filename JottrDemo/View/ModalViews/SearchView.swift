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
    @State private var highlightedSearchedText = AttributedString("")
   
    var body: some View {
        NavigationView {
            List {
                Text("Recently Modified")
                    .font(.system(.title, design: .serif))
                    .textSelection(.enabled)
                    .listRowSeparator(.hidden)
                
                ForEach(searchResults, id: \.self) { eachStory in
                    NavigationLink(destination: Text(eachStory)) {
                        Text(eachStory)
                            .foregroundColor(.secondary)
                            .font(.system(.subheadline, design: .serif))
                            // limit the amount of text shown in each item in the list
                            .lineLimit(3)
                            .textSelection(.enabled)
                    }
                }
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Seek It") {
                //provide tappable suggestions as the user types
                Text("\(searchResults.count) Pages")
                    .font(.system(.title, design: .serif))
                    .textSelection(.enabled)
                
                ForEach(searchResults, id: \.self) { result in
                    Text("\(result)").searchCompletion(result)
                        .foregroundColor(.green)
                        .font(.system(.body, design: .serif))
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
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
        .onChange(of: searchQuery) { _ in highlightText() }
    }
    
    var searchResults: [AttributedString] {
        var stories: [AttributedString]!
        
        if searchQuery.isEmpty {
            for tale in workOfFiction {
                if let unwrappedStory = tale.complStory {
                    let attributedStory = AttributedString(unwrappedStory)
                    stories = [attributedStory] //[unwrappedStory] // now, how to cnvert from String to AttributedString
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
                    let attributedStory = AttributedString(unwrappedStory)
                    stories = [attributedStory] //+= [unwrappedStory]
                }
            }
            // may need to put the code back to what it was and convert it after in highlightText()
            return stories.filter { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    private func highlightText() {
        if !searchQuery.isEmpty {
            print("sag, Hi!")
            searchResults
        }
        
        let range = highlightedSearchedText.range(of: "\(searchQuery)")!
        highlightedSearchedText[range].foregroundColor = .red
    }
}
