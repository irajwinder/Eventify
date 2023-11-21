//
//  DataManager.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//

import CoreData

//Singleton Class
class DataManager: NSObject {
    
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
   
    private override init() {
        super.init()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Eventify")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    func saveUser(userName: String, userEmail: String, userPassword: String, userDateOfBirth: Date, userProfilePhoto: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext

        if let entity = NSEntityDescription.entity(forEntityName: "User", in: context) {
            let user = NSManagedObject(entity: entity, insertInto: context)
            user.setValue(userName, forKey: "userName")
            user.setValue(userEmail, forKey: "userEmail")
            user.setValue(userPassword, forKey: "userPassword")
            user.setValue(userDateOfBirth, forKey: "userDateOfBirth")
            user.setValue(userProfilePhoto, forKey: "userProfilePhoto")
        }
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("User data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchUser(userEmail: String) -> User? {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        
        do {
            // Fetch the User based on the fetch request
            let users = try context.fetch(fetchRequest)
            return users.first // Return the first user found
        } catch let error as NSError {
            // Handle the error
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func updateUser(user: User, userName: String, userEmail: String, userDateOfBirth: Date, profilePicticture: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext

        user.userName = userName
        user.userEmail = userEmail
        user.userDateOfBirth = userDateOfBirth
        user.userProfilePhoto = profilePicticture
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("User data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func saveEvent(user: User, eventTitle: String, eventDetail: String, eventImage: String, eventLongitude: Double, eventLatitude: Double) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the Event entity in the context
        let event = Event(context: context)
        event.setValue(user, forKey: "user")
        
        event.eventTitle = eventTitle
        event.eventDetail = eventDetail
        event.eventImage = eventImage
        event.eventLongitude = eventLongitude
        event.eventLatitude = eventLatitude
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Event data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchEvents() -> [Event]? {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext

        do {
            // Fetch all events based on the fetch request
            let events = try context.fetch(Event.fetchRequest())
            return events
        } catch let error as NSError {
            // Handle the error
            print("Could not fetch events. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func saveComment(event: Event, user: User , eventComment: String) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Create a new instance of the Comment entity in the context
        let comment = Comment(context: context)
        comment.setValue(event, forKey: "event")
        comment.setValue(user, forKey: "user")
        
        comment.text = eventComment
        
        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Comment saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteEntity(_ entity: NSManagedObject) {
        // Access the view context from the persistent container
        let context = persistentContainer.viewContext
        // Remove the entity from the context
        context.delete(entity)

        do {
            // Attempting to save the changes made to the context
            try context.save()
            print("Entity deleted successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}

let dataManagerInstance = DataManager.sharedInstance

