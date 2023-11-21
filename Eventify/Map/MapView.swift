//
//  MapView.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/16/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var events: [Event]?
    
    var body: some View {
        Map() {
            ForEach(events ?? [], id: \.self) { event in
                Marker(event.eventTitle ?? "",  systemImage: "calendar", coordinate: CLLocationCoordinate2D(latitude: event.eventLatitude, longitude: event.eventLongitude))
            }
        }
        .onAppear() {
            if let allEvents = dataManagerInstance.fetchEvents() {
                    events = allEvents
            }
        }
    }
}

#Preview {
    MapView()
}
