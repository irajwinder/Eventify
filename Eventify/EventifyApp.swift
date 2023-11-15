//
//  EventifyApp.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/14/23.
//

import SwiftUI

@main
struct EventifyApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn == true {
                TabBarView()
            } else {
                Register()
            }
        }
    }
}
