//
//  EventView.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//

import SwiftUI

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    func fetchEvents() {
        guard let loggedInUserID = loggedInUserID,
              let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch user")
            return
        }
       
        guard let fetch = user.events as? Set<Event> else {
            print("Could not fetch trips for the user")
            return
        }
        self.events = Array(fetch)
   }
}

struct EventView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var isAddEventView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.events, id: \.self) { event in
                    NavigationLink(destination: EventDetailsView(selectedTrip: event)) {
                        CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: event.eventImage ?? ""))
                        VStack(alignment: .leading) {
                            Text(event.eventTitle ?? "")
                                .font(.headline)
                        }
                    }
                }.onDelete { indexSet in
                    for index in indexSet {
                        let event = viewModel.events[index]
                        // Delete the event picture from the file manager
                        if let eventImage = event.eventImage {
                            fileManagerClassInstance.deleteImageFromFileManager(relativePath: eventImage)
                        }
                        
                        // Delete the event picture from the coredata
                        DataManager.sharedInstance.deleteEntity(event)
                        
                       
                    }
                    viewModel.fetchEvents()
                }
            }.navigationTitle("Events")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isAddEventView = true
                        }) {
                            Label("Save", systemImage: "plus")
                        }
                    }
                }
        
        }.sheet(isPresented: $isAddEventView) {
           // AddTripView()
           AddEventView(viewModel: viewModel)
        }
        .onAppear(perform: {
            viewModel.fetchEvents()
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            print(paths[0])
        })
    }
}


#Preview {
    EventView()
}
