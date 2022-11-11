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
    @NSManaged public var origin: Story?
    
    public var formattedDateDiscarded: String {
        // using a date formatter to make sure a task date is presented in human-readable form:
        dateDiscarded?.formatted(date: .long, time: .shortened) ?? "Unknown Date"
    }
}

extension TrashBin: Identifiable { }
