//
//  TrashBin+CoreDataProperties.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/11/22.
//

import CoreData
import Foundation

extension TrashBin {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrashBin> {
        return NSFetchRequest<TrashBin>(entityName: "TrashBin")
    }
    
    @NSManaged public var dateDiscarded: Date?
    // This is an NSSet, which could contain anything at all, Core Data hasn’t restricted it to just instances of Candy.
//    @NSManaged public var story: NSSet? 
    
    public var formattedDateDiscarded: String {
        // using a date formatter to make sure a task date is presented in human-readable form:
        dateDiscarded?.formatted(date: .long, time: .shortened) ?? "Unknown Date"
    }
    
    /*
     First convert candy: NSSet from an NSSet to a Set<TrashBin> – a Swift-native type where we know the types of its
     contents.
     Second convert that Set<TrashBin> into an array, so that ForEach can read individual values from there.
     Third sort that array, so the TrashBin content come in a sensible order.
     */
//    public var storyArray: [Story] {
//        let set = story as? Set<Story> ?? []
//
//        return set.sorted {
//            $0.wrappedDateCreated < $1.wrappedDateCreated
//        }
//    }
}

// MARK: Generated accessors for trash bin
//extension TrashBin {
//    @objc(addStoryObject:)
//    @NSManaged public func addToStory(_ value: Story)
//
//    @objc(removeStoryObject:)
//    @NSManaged public func removeFromStory(_ value: Story)
//
//    @objc(addStory:)
//    @NSManaged public func addStory(_ values: NSSet)
//
//    @objc(removeStory:)
//    @NSManaged public func removeFromStory(_ values: NSSet)
//}

extension TrashBin: Identifiable { }
