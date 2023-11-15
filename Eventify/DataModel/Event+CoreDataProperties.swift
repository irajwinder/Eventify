//
//  Event+CoreDataProperties.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventTitle: String?
    @NSManaged public var eventDetail: String?
    @NSManaged public var eventImage: String?
    @NSManaged public var eventLocation: String?
    @NSManaged public var user: User?
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension Event {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension Event : Identifiable {

}
