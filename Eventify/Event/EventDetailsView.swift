//
//  EventDetailsView.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//

import SwiftUI

import SwiftUI

struct EventDetailsView: View {
    let selectedEvent: Event
    @State private var comments: [Comment] = []
    @State private var newComment: String = ""
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: selectedEvent.eventImage ?? ""))
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                HStack {
                    Text("Event Name:")
                        .font(.headline)
                    
                    Text(selectedEvent.eventTitle ?? "")
                        .font(.caption)
                }
                
                HStack {
                    Text("Longitude:")
                        .font(.headline)
                    Text("\(selectedEvent.eventLongitude)")
                        .font(.caption)
                    Spacer()
                    Text("Latitude:")
                        .font(.headline)
                    Text("\(selectedEvent.eventLatitude)")
                        .font(.caption)
                }
                
                HStack {
                    Text("Event Details:")
                        .font(.headline)
                    
                    Text(selectedEvent.eventDetail ?? "")
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                }
                
                HStack {
                    TextField("Add a comment", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing, 8)
                    
                    Button(action: {
                        postComment()
                    }) {
                        Text("Post")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                Section(header: Text("Comments")) {
                    ForEach(comments, id: \.id) { comment in
                        CommentView(comment: comment) {
                            deleteComment(comment)
                        }
                    }
                }
            }
            .padding()
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
    
    func deleteComment(_ comment: Comment) {
        dataManagerInstance.deleteEntity(comment)
        fetchComments()
    }
}

struct CommentView: View {
    let comment: Comment
    let onDelete: () -> Void
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.text ?? "")
                Text("by: \(comment.user?.userEmail ?? "")")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            // Only show the delete button if the logged-in user is the owner of the comment
            if comment.user?.userEmail == loggedInUserID {
                Button(action: {
                    onDelete()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
    }
}

#Preview {
    EventDetailsView(selectedEvent: Event())
}
