//
//  AddEventView.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//

import SwiftUI
import PhotosUI
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct AddEventView: View {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var viewModel: EventViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var eventTitle: String = ""
    @State private var eventDetail: String = ""
    @State private var eventLatitude: Double = 0.0
    @State private var eventLongitude: Double = 0.0

    @State private var eventImage: String?
    
    @State private var selectedPickerImage: PhotosPickerItem?
    @State private var eventPhotoImage: Image?
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    @State private var isSelectingFromGallery = true
    @State private var imageURL: String = ""
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var annotations: [AnnotationItem] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Event Information")) {
                        HStack {
                            CustomText(text: "Event Title", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Event Title", text: $eventTitle)
                                .padding()
                        }
                      
                        HStack {
                            CustomText(text: "Event Details", textSize: 20, textColor: .black)
                            CustomMultilineTextField(placeholder: "Event Details", text: $eventDetail)
                        }
                        
                        VStack(alignment: .leading) {
                            CustomText(text: "Location", textSize: 20, textColor: .black)
                                
                            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [AnnotationItem(coordinate: locationManager.userLocation ?? CLLocationCoordinate2D())]) { location in
                                MapPin(coordinate: location.coordinate, tint: .blue)
                            }
                            .frame(height: 300)
                            .onAppear {
                                if let userLocation = locationManager.userLocation {
                                    // Update the region to center on the user's location
                                    region.center = userLocation
                                }
                            }
                            .onReceive(locationManager.$userLocation) { newLocation in
                                    eventLongitude = newLocation?.longitude ?? 0.0
                                    eventLatitude = newLocation?.latitude ?? 0.0
                            }
                            Text("Latitude \(eventLatitude)")
                            Text("Longitude \(eventLongitude)")
                        }
                        
                        HStack {
                            CustomText(text: "Event Picture", textSize: 20, textColor: .black)
                            Spacer()
                            
                            Picker("Source", selection: $isSelectingFromGallery) {
                                Text("Gallery").tag(true)
                                Text("URL").tag(false)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                        }

                        if isSelectingFromGallery {
                            PhotosPicker(
                                "Select photo",
                                selection: $selectedPickerImage,
                                matching: .images
                            )
                            .onChange(of: selectedPickerImage) {
                                Task {
                                    if let data = try? await selectedPickerImage?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            eventPhotoImage = Image(uiImage: uiImage)
                                            // Save image to file manager and get the URL
                                            if let imageURL = fileManagerClassInstance.saveImageToFileManager(uiImage, folderName: "EventPicture", fileName: "\(UUID().uuidString).jpg") {
                                                eventImage = imageURL
                                            }
                                            return
                                        }
                                    }
                                    print("Failed")
                                }
                            }
                        } else {
                            HStack {
                                TextField("Enter Image URL", text: $imageURL)
                                    .padding()
                                
                                Button("Download") {
                                    ValidateAndSaveRemotePhoto()
                                }
                            }

                            if let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 300, height: 300)
                                        case .failure:
                                            Text("There was an error loading the image")
                                        case .empty:
                                            ProgressView()
                                        @unknown default:
                                            Text("Unknow Error")
                                        }
                                    }.frame(width: 300, height: 300)
                                }
                        }
                        
                        VStack {
                            if let eventPhotoImage {
                                eventPhotoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            }
                        }
                    }
                }
            }.navigationBarTitle("Add Event")
                .toolbar {
                    ToolbarItem {
                        Button("Save", action: {
                            SaveAndValidateEvent()
                        })
                    }
                }.alert(isPresented: $showAlert) {
                    alert!
                }
        }
    }
    
    //download and save an image from the given URL
    func downloadAndSaveImage(url: URL) {
        // Create a data task using URLSession to fetch data from the given URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if there is valid data and convert it to a UIImage
            if let data = data, let uiImage = UIImage(data: data) {
                // Save image to file manager and get the URL
                if let imageURL = fileManagerClassInstance.saveImageToFileManager(uiImage, folderName: "EventPicture", fileName: "\(UUID().uuidString).jpg") {
                    DispatchQueue.main.async {
                        // Update the eventImage property on the main thread
                        eventImage = imageURL
                    }
                }
            } else if let error = error {
                print("Error downloading image: \(error)")
            }
        }
        // Resume the data task to initiate the download
        task.resume()
    }
    
    func ValidateAndSaveRemotePhoto() {
        guard Validation.isValidName(imageURL) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please enter Image URL")
            return
        }
        
        guard let url = URL(string: imageURL) else {
            print("Invalid URL")
            return
        }
        downloadAndSaveImage(url: url)
    }

    func SaveAndValidateEvent() {
        guard Validation.isValidName(eventTitle) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Event Title")
            return
        }
        
        guard Validation.isValidName(eventDetail) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Event Details")
            return
        }
        
        guard let eventImage = eventImage else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please select an event photo")
            return
        }
        
        guard let loggedInUserID = loggedInUserID,
              let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch user")
            return
        }
        
        guard eventLatitude != 0.0 && eventLongitude != 0.0 else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please select event Location")
            return
        }
        
        // Save Event Details
        dataManagerInstance.saveEvent(
            user: user,
            eventTitle: eventTitle,
            eventDetail: eventDetail,
            eventImage: eventImage,
            eventLongitude: eventLongitude,
            eventLatitude: eventLatitude
        )
        
        // Show a success alert
        showAlert = true
        alert = Validation.showAlert(title: "Success", message: "Successfully Saved the data")
        
        // Dismiss the sheet after saving the event
        dismiss()
        // Update the events in the ViewModel
        viewModel.fetchEvents()
    }
}

#Preview {
    AddEventView(viewModel: EventViewModel())
}
