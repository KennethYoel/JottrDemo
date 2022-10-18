//
//  StoryListView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import SwiftUI



struct StoryListView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var stories: FetchedResults<Story>
    
    @State private var isShareViewPresented: Bool = false
    @State private var isShowingLoginScreen: Bool = false
    @State private var isShowingStoryEditorScreen: Bool = false
    @State private var isShowingFeedbackScreen: Bool = false
    @State private var isShowingSettingsScreen: Bool = false
    @State private var isShowingSearchScreen: Bool = false
    @State private var isActive: Bool = false
    
    var isShowingRecentList: Bool = false
    
    var body: some View {
        VStack {
            List {
                /*
                 We don’t need to provide an identifier for the ForEach because all
                 Core Data’s managed object class conform to Identifiable
                 automatically, but things are trickier when it comes to creating
                 views inside the ForEach. Swift will generate a memoize initializer
                 for all its struct, memoizer that will accept the parameters of the
                 struct.
                 */
                // for each story in the array, create a listing row
                ForEach(listOfStories, content:  StoryListRow.init).onDelete(perform: deleteStory) // swipe to delete
            }
            .sheet(isPresented: $isShareViewPresented, onDismiss: { // the sheet is shown when isShareViewPresented is true
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: ["The Story"]) //[URL(string: "https://www.swifttom.com")!]
            })
        } // Complete Works -> Opera Omnia
        .fullScreenCover(isPresented: $isShowingStoryEditorScreen, content: {
            NavigationView {
                StoryEditorView()
            }
        })
        .sheet(isPresented: $isShowingLoginScreen) { LoginView() }
        .sheet(isPresented: $isShowingSearchScreen) { SearchView() }
        .navigationTitle(pageTitle())
        .toolbar { storyListToolbar }
        .magnifyingGlass(show: $isShowingSearchScreen)
    }
    
    var listOfStories: [Story] {
        var fetchedStories: [Story] = []
        
        if !isShowingRecentList {
            fetchedStories.append(contentsOf: stories)
            return fetchedStories
        } else {
            // filter returns stories from the last seven days.
            let sortedByDate = stories.filter {
                guard let unwrappedValue = $0.creationDate else {
                    return false
                }
                return unwrappedValue > (Date.now - 604_800) // 604800 sec. is seven days in seconds
//                $0.creationDate! > (Date.now - 604_800)
            }
            fetchedStories.append(contentsOf: sortedByDate)
            
            return fetchedStories
        }
    }
    
    var storyListToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                isShowingStoryEditorScreen.toggle()
            } label: {
                Label("New Story", systemImage: "square.and.pencil")
            }
            
            Menu {
                Button {
                    isShowingLoginScreen.toggle()
                } label: {
                    Label("Login", systemImage: "lanyardcard")
                }
                
                Button {
                    isShowingFeedbackScreen.toggle()
                } label: {
                    Label("Feedback", systemImage: "pencil.and.outline")
                }
                
                Button {
    //                        showingImagePicker.toggle()
                } label: {
                    Text("Settings")
                    Image(systemName: "slider.horizontal.3")
                }
            } label: {
                 Image(systemName: "gearshape.2")
            }
        }
    }
    
    private func pageTitle() -> String {
        var title: String!
        if !isShowingRecentList {
            title = "Collection"
        } else {
            let pastDateResults = (Date.now - 604800).formatted(date: .abbreviated, time: .omitted)
            title = "From " + pastDateResults
        }
        
        return title
    }
    
    private func deleteStory(at offsets: IndexSet) {
        for offset in offsets {
            let story = stories[offset]
            // delete from in memory storage
            moc.delete(story)
        }
        // write the changes out to persistent storage
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
