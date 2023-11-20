//
//  EventDetailsView.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//

import SwiftUI

struct EventDetailsView: View {
    let selectedEvent: Event
    @State private var comments: [Comment] = []
    @State private var newComment: String = ""
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    var body: some View {
        VStack {
            CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: selectedEvent.eventImage ?? ""))
                .frame(width: 200, height: 200)
                .cornerRadius(8)
            
            Text(selectedEvent.eventTitle ?? "")
                .font(.title)
                .padding()
            
            HStack {
                Text("Longitude: \(selectedEvent.eventLongitude)")
                Spacer()
                Text("Latitude: \(selectedEvent.eventLatitude)")
            }
            .padding()
            
            Text("Event Details:")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text(selectedEvent.eventDetail ?? "")
                .multilineTextAlignment(.leading)
                .padding()
            
            
            // Add comment section
            List {
                Section(header: Text("Comments")) {
                    ForEach(comments, id: \.id) { comment in
                        HStack {
                            Text(comment.text ?? "")
                            Text("by: \(comment.user?.userName ?? "")")
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                    }
                }
                
                Section {
                    HStack {
                        TextField("Add a comment", text: $newComment)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Post") {
                            postComment()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding()
            
            Spacer()
            
        }
        .navigationTitle("Event Details")
        .onAppear {
            fetchComments()
        }
    }
    
    func fetchComments() {
        guard let fetch = selectedEvent.comments as? Set<Comment> else {
            print("Could not fetch comments for the event")
            return
        }
        self.comments = Array(fetch)
    }

    
    func postComment() {
        guard let loggedInUserID = loggedInUserID,
              let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch user")
            return
        }
        
        dataManagerInstance.saveComment(
            event: selectedEvent, 
            user: user,
            eventComment: newComment
        )
        
        // Clear the text field after posting
        newComment = ""
        fetchComments()
    }
}

#Preview {
    EventDetailsView(selectedEvent: Event())
}
