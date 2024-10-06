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
    @State private var isLoading: Bool = false
    
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
            VStack {
                HStack {
                    Text("Amount:")
                    TextField("Enter number", text: $inputNumber)
                        .keyboardType(.phonePad) // Show numeric keyboard
                        .onChange(of: inputNumber) { newValue in
                            // Allow only numbers and a decimal point
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            
                            // Ensure there's only one decimal point
                            let components = filtered.split(separator: ".")
                            if components.count > 2 {
                                inputNumber = String(components[0]) + "." + components[1]
                            } else {
                                inputNumber = filtered
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button(action: {
                    isLoading = true
                    if let number = Double(inputNumber), let member = selectedMember {
                        // Use the number and selected member as needed
                        print("Selected member: \(member.name), Number: \(number)")
                        Task {
                            let result = await mealManager.addBazar(id: member.id, amount: number)
                            
                            isLoading = false
                            if result {
                                presentationMode.wrappedValue.dismiss()
                            }
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
