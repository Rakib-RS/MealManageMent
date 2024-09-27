//
//  AddTransactionView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var mealManager = MealManager.shared
    @State var showPopup: Bool = false
    @State var inputText = ""
    @State var showToast: Bool = false
    @State var message: String = "Deleted Successfully"
    
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            
            NavigationView {
                VStack {
                    NavigationLink(destination: AddMealsView(mealManager: mealManager)) {
                        Text("Add Meals")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    NavigationLink(destination: AddBazarView(mealManager: mealManager)) {
                        Text("Add Bazar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    NavigationLink(destination: DateMemberMatrixView(members: mealManager.members)) {
                        Text("Excel View")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    // Button to trigger popup
                    Button("Reset All Data") {
                        showPopup = true
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
            }
            
            // Popup overlay with dimmed background
            if showPopup {
                Color.black.opacity(0.4) // Dimmed background
                    .ignoresSafeArea()
                    .zIndex(1) // Make sure the background is behind the popup
                
                // Popup content
                VStack {
                    Text("Are you sure to Reset All Data?")
                        .font(.headline)
                        .padding()
                    
                    TextField("Type password", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Cancel") {
                            showPopup = false
                        }
                        .font(.system(size: 16))
                        .frame(width: 80, height: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Divider().frame(width: 20) // Space between buttons
                        
                        Button("OK") {
                            print("OK pressed with input: \(inputText)")
                            showPopup = false
                            let isDeleted = mealManager.clearMemeberData(password: inputText)
                            showToast = true
                            
                            message = isDeleted ? "Data reset successfully" : "InCorrect password"
                        }
                        .font(.system(size: 16))
                        .frame(width: 80, height: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding()
                .frame(width: 300, height: 220)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .zIndex(2) // Ensure popup content is above the dimmed background
            }
            
            // Toast logic: Apply toast at the ZStack level
            if showToast {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.body)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.5))
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showToast = false // Hide the toast after 2 seconds
                    }
                }
            }
        }
        .tabItem {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 25))
                Text("Add")
            }
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
