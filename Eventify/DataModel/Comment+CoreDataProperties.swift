//
//  Comment+CoreDataProperties.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/20/23.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var text: String?
    @NSManaged public var event: Event?
    @NSManaged public var user: User?

}

extension Comment : Identifiable {

}
