//
//  CustomComponents.swift
//  Eventify
//
//  Created by Rajwinder Singh on 11/15/23.
//

import SwiftUI

struct CustomText: View {
    var text: String
    var textSize: CGFloat
    var textColor: Color
    var body: some View {
        Text(text)
            .font(.system(size: textSize))
            .foregroundColor(textColor)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
}

struct CustomMultilineTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 50)
            }
            
            TextEditor(text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(minHeight: 100)
                .multilineTextAlignment(.leading)
                .lineSpacing(5)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
    }
}

struct CustomSecureTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

struct CustomImage: View {
    var profilePicture: UIImage?
    var body: some View {
        VStack {
            Image(uiImage: profilePicture ?? UIImage(systemName: "person.fill")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
        }
    }
}

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.automatic)
            .padding()
    }
}

struct CustomCoverPhoto: View {
    var coverPhoto: UIImage?
    
    var body: some View {
        VStack {
            Image(uiImage: coverPhoto ?? UIImage(systemName: "person.fill")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}



#Preview {
    Group {
        CustomText(text: "Text", textSize: 20, textColor: .black)
            .padding()
        
        CustomTextField(placeholder: "Enter text", text: .constant(""))
            .padding()
        
        CustomMultilineTextField(placeholder: "Enter multiline text", text: .constant(""))
            .padding()
        
        CustomSecureTextField(placeholder: "Enter text", text: .constant(""))
            .padding()
        
        CustomImage(profilePicture: UIImage(named: "logo"))
            .padding()
        
        CustomDatePicker(selectedDate: .constant(Date()))
                   .padding()

        CustomCoverPhoto(coverPhoto: UIImage(named: "logo"))
        
        SearchBar(text: .constant("Search"))
    }
}
