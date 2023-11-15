//
//  Comment+CoreDataProperties.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
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

}

extension Comment : Identifiable {

}
