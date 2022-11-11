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

    @NSManaged public var id: UUID?
    @NSManaged public var creationDate: Date?
    @NSManaged public var genre: String?
    @NSManaged public var theme: String?
    @NSManaged public var sessionPrompt: String?
    @NSManaged public var complStory: String?
    // This is an NSSet, which could contain anything at all, Core Data hasn’t restricted it to just instances of Candy.
    @NSManaged public var trashBin: NSSet? 
    
    /*
     adding computed properties that help us access the optional values safely, while also letting us store your nil
     coalescing code all in one place. For example, adding this as a property on Movie ensures that we always have a valid
     title string to work with-This way the whole rest of your code doesn’t have to worry about Core Data’s optionality,
     and if you want to make changes to default values you can do it in a single file.
     */
    public var formattedDate: String {
        // using a date formatter to make sure a task date is presented in human-readable form:
        creationDate?.formatted(date: .long, time: .shortened) ?? "Unknown Date"
    }
    public var wrappedGenre: String {
        genre ?? "fantasy"
    }
    public var wrappedTheme: String {
        theme ?? "custom"
    }
    public var wrappedSessionPrompt: String {
        sessionPrompt ?? "Unkown Prompt"
    }
    public var wrappedComplStory: String {
        complStory ?? "Unkown Story"
    }
    
    /*
     First convert candy: NSSet from an NSSet to a Set<TrashBin> – a Swift-native type where we know the types of its
     contents.
     Second convert that Set<TrashBin> into an array, so that ForEach can read individual values from there.
     Third sort that array, so the TrashBin content come in a sensible order.
     */
    public var trashBinArray: [TrashBin] {
        let set = trashBin as? Set<TrashBin> ?? []
        
        return set.sorted {
            $0.dateDiscarded ?? Date() < $1.dateDiscarded ?? Date()
        }
    }
}

// MARK: Generated accessors for trash bin
extension Story {
    @objc(addTrashBinObject:)
    @NSManaged public func addToTrashBin(_ value: TrashBin)

    @objc(removeTrashBinObject:)
    @NSManaged public func removeFromTrashBin(_ value: TrashBin)

    @objc(addTrashBin:)
    @NSManaged public func addTrashBin(_ values: NSSet)

    @objc(removeTrashBin:)
    @NSManaged public func removeFromTrashBin(_ values: NSSet)
}

extension Story: Identifiable { }
