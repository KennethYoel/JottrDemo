//
//  SearchView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import SwiftUI

//struct SearchQueryView: View {
//    var searchable = SearchView()
//
//    var body: some  View {
//
//    }
//}

struct SearchView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)]) var narratives: FetchedResults<Story>
    @State private var searchQuery: String = ""
    @State private var searching: Bool = false
    @ObservedObject var activateListDetail: PerformNavigation
   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if isSearching {
                  Text("\(storyRequested.count) Items")
                        .font(.system(.title2, design: .serif))
                        .textSelection(.enabled)
                } else {
                    Text("Recently Modified")
                        .padding(.leading)
                        .font(.system(.title2, design: .serif))
                        .textSelection(.enabled)
                }
                
                List(storyRequested, id: \.self) { item in //
                    // for each story in the array, create a listing row
                    Text(LocalizedStringKey(item.wrappedComplStory)) // requesting localization
                        .foregroundColor(.secondary)
                        .font(.system(.subheadline, design: .serif))
                        .lineLimit(3)  // limit the amount of text shown in each item in the list
                        .onTapGesture(perform: {
                            activateListDetail.showListingRow.toggle()
                            dismiss()
                            debugPrint("Tap Gesture and this is: \(activateListDetail.showListingRow)")
                        })
                    
//                    NavigationLink(destination: StoryListDetailView(story: item)) {
//                        Text(LocalizedStringKey(item.wrappedComplStory)) // requesting localization
//                            .foregroundColor(.secondary)
//                            .font(.system(.subheadline, design: .serif))
//                            .lineLimit(3)  // limit the amount of text shown in each item in the list
//                    }
                    
                }
                .listStyle(.inset)
                .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "All") {
                    ForEach(highlightedResults, id: \.self) { result in  //provide tappable suggestions as the user types
                        Text(result) // .searchCompletion(convertToString(contentOf: result))
                            .font(.system(.subheadline, design: .serif))
                            .lineLimit(3) // limit the amount of text shown in each item in the list
                    }
                }
                .onSubmit(of: .search) {
                    debugPrint("Search Submitted")
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
    }
    
    var searchResults: [String] {
        get {
            var stories: [String] = []
            
            // append Story in Core Data to stories array
            for eachStory in narratives {
                stories += [eachStory.wrappedComplStory]
            }
            /*
             localizedCaseInsensitiveContains() lets us
             check any part of the search strings, without
             worrying about uppercase or lowercase characters
             */
            return searchQuery.isEmpty ? stories : stories.filter { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    var storyRequested: [Story] {
        get {
            var storyContents: [Story] = []
            
            if searchQuery.isEmpty {
                storyContents.append(contentsOf: narratives)
            } else {
                let filteredStoryContent = narratives.filter {
                    $0.wrappedComplStory.localizedCaseInsensitiveContains(searchQuery)
                }
                storyContents.append(contentsOf: filteredStoryContent)
            }
            
            return storyContents
        }
    }
    
    var highlightedResults: [AttributedString] {
        get {
            var attributedResults: [AttributedString] = []
            
            for item in storyRequested {
                // convert the item String to AttributedString
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
    
    func convertToString(contentOf attribute: AttributedString) -> String {
        let attributedSample = NSMutableAttributedString(attribute)
     
        return attributedSample.string
    }
    
    private func openPage() {
        
    }
}
