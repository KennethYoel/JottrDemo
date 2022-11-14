//
//  Story+CoreDataProperties.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import CoreData
import Foundation

extension Story {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Story> {
        return NSFetchRequest<Story>(entityName: "Story")
    }
    
    @NSManaged public var complStory: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateDiscarded: Date?
    @NSManaged public var genre: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isDiscarded: DarwinBoolean
    @NSManaged public var sessionPrompt: String?
    @NSManaged public var theme: String?
//    @NSManaged public var origin: TrashBin?
   
    
    /*
     adding computed properties that help us access the optional values safely, while
     also letting us store your nil coalescing code all in one place. For example, adding this as a property on Jottr
     ensures that we always have a valid value to work with-This way the whole rest of your code doesn’t have to worry
     about Core Data’s optionality, and if you want to make changes to default values you can do it in a single file.
     */
    public var wrappedComplStory: String {
        complStory ?? "Unkown Story"
    }
    public var formattedDateCreated: String {
        // using a date formatter to make sure a task date is presented in human-readable form:
        dateCreated?.formatted(date: .long, time: .shortened) ?? "Unknown Date"
    }
    public var wrappedDateCreated: Date {
        dateCreated ?? Date.now
    }
    public var formattedDateDiscarded: String {
        // using a date formatter to make sure a task date is presented in human-readable form:
        dateDiscarded?.formatted(date: .long, time: .shortened) ?? "Unknown Date"
    }
    public var wrappedDateDiscarded: Date {
        dateDiscarded ?? Date.now
    }
    public var wrappedGenre: String {
        genre ?? "fantasy"
    }
    public var wrappedIsDiscarded: Bool {
        if isDiscarded == DarwinBoolean(true) {
            return true
        } else {
            return false
        }
    }
    public var wrappedSessionPrompt: String {
        sessionPrompt ?? "Unkown Prompt"
    }
    public var wrappedTheme: String {
        theme ?? "custom"
    }
}

extension Story: Identifiable { }
