//
//  EventifyApp.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/14/23.
//

import SwiftUI

@main
struct EventifyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
