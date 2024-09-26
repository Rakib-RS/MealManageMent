//
//  AddBazarView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct Member3: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var phoneNumber: String
}

struct AddBazarView: View {
    @StateObject var mealManager: MealManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedMember: Member? = nil
    @State private var inputNumber: String = ""
    
    var body: some View {
        VStack {
            // Custom Picker
            HStack {
                Text("Select a Member:")
                    .font(.headline)
                    .padding(.trailing)
                
                Menu {
                    // Dropdown options
                    ForEach(mealManager.members) { member in
                        Button(action: {
                            selectedMember = member // Set selected member
                        }) {
                            Text(member.name)
                        }
                    }
                } label: {
                    // Display selected member or prompt
                    Text(selectedMember?.name ?? "None")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(selectedMember != nil ? .black : .gray)
                }
            }
            .padding()
            
            // Input box for entering a number
            HStack {
                TextField("Enter number", text: $inputNumber)
                    .keyboardType(.numberPad) // Show numeric keyboard
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Handle the action when the number is entered
                    if let number = Double(inputNumber), let member = selectedMember {
                        // Use the number and selected member as needed
                        print("Selected member: \(member.name), Number: \(number)")
                        mealManager.addBazar(id: member.id, amount: number)
                        mealManager.prepareSummary()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Select Member")
    }
}

struct SelectMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddBazarView(mealManager: MealManager.shared)
    }
}