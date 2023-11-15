//
//  TabBarView.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            EventView()
                .tabItem {
                    Label("Trip", systemImage: "airplane")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    TabBarView()
}
