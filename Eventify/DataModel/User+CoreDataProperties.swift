//
//  User+CoreDataProperties.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userDateOfBirth: Date?
    @NSManaged public var userEmail: String?
    @NSManaged public var userName: String?
    @NSManaged public var userPassword: String?
    @NSManaged public var userProfilePhoto: String?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension User {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension User : Identifiable {

}
