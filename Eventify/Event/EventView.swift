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
    @State private var selectedView = 0
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $selectedView, label: Text("View")) {
                    Text("List").tag(0)
                    Text("Grid").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                SearchBar(text: $searchText)

                if selectedView == 0 {
                    List {
                        ForEach(filteredEvents, id: \.self) { event in
                            NavigationLink(destination: EventDetailsView(selectedTrip: event)) {
                                ListView(event: event)
                            }
                        }
                        .onDelete { indexSet in
                            deleteEvents(offsets: indexSet)
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredEvents, id: \.self) { event in
                                NavigationLink(destination: EventDetailsView(selectedTrip: event)) {
                                    GridView(event: event)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddEventView = true
                    }) {
                        Label("Add Event", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddEventView) {
                AddEventView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchEvents()
                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                print(paths[0])
            }
        }
    }

    var filteredEvents: [Event] {
        if searchText.isEmpty {
            return viewModel.events
        } else {
            let searchTextLowercased = searchText.lowercased()
            return viewModel.events.filter { $0.eventTitle?.lowercased().contains(searchTextLowercased) == true }
        }
    }

    private func deleteEvents(offsets: IndexSet) {
        for index in offsets {
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
}

struct ListView: View {
    let event: Event

    var body: some View {
        HStack {
            CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: event.eventImage ?? ""))
                .frame(width: 50, height: 50)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(event.eventTitle ?? "")
                    .font(.headline)
            }
        }
    }
}

struct GridView: View {
    let event: Event

    var body: some View {
        VStack {
            CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: event.eventImage ?? ""))
                .frame(width: 150, height: 150)
                .cornerRadius(8)

            Text(event.eventTitle ?? "")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}


#Preview {
    EventView()
}
