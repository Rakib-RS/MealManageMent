//
//  AddMemberView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

import SwiftUI

struct AddMemberView: View {
    @Environment(\.presentationMode) var presentationMode
    //@Binding var members: [Member]
    @StateObject var mealManager: MealManager
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea() // Background color
            
            VStack(spacing: 20) {
                // Form Header
                Text("Add New Member")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                // Form Fields
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "Name", text: $name)
                    CustomTextField(placeholder: "Phone Number", text: $phoneNumber, keyboardType: .phonePad)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Save Button
                Button(action: {
                    isLoading = true
                    Task {
                        let result = await mealManager.addMember(name: name, phoneNumber: phoneNumber)
                        isLoading = false
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 300, height: 50)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Submit")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .font(.headline)
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .keyboardType(keyboardType)
        }
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        //members: .constant([Member(name: "John Doe", phoneNumber: "123456789")])
        AddMemberView(mealManager: MealManager.shared)
    }
}
