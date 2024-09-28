//
//  CustomPopup.swift
//  MealManagement
//
//  Created by Rakib on 28/9/24.
//

import SwiftUI

struct CustomPopupView: View {
    @State var mealManager = MealManager.shared
    @State var inputText: String = ""
    @State var isPasswordVisible: Bool = false
    
    @Binding var showPopup: Bool
    @Binding var showToast: Bool
    @Binding var message: String
    
    var body: some View {
        VStack {
           // Spacer()
            Text("Are you sure to Reset All Data?")
                .font(.headline)
                .padding()
            
            HStack {
                if isPasswordVisible {
                    TextField("Type password", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                } else {
                    SecureField("Type password", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }, label: {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                })
            }
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
                    inputText = ""
                }
                .font(.system(size: 16))
                .frame(width: 80, height: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.top, 10)
            //Spacer()
        }
    }
}

#Preview {
    CustomPopupView(showPopup: .constant(false), showToast: .constant(false), message: .constant(""))
}
