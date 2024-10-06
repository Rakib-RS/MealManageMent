//
//  AddMealsView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct AddMealsView: View {
    @StateObject var mealManager: MealManager
    @Environment(\.presentationMode) var presentationMode
    
    @State var date: Date = Date()
    @State private var isOneSelected: Bool = true
    @State private var isLoading: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }
    
    var body: some View {
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)   // Extract day (dd)
        let month = calendar.component(.month, from: date)  // Extract month (MM)
        
        VStack {
            // DatePicker for selecting the date
            DatePicker("Select Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
            //.labelsHidden()
                .padding()
            
            // Display the formatted date
            Text("Selected Date: \(dateFormatter.string(from: date))")
                .font(.headline)
                .padding()
            
            HStack {
                Text("InCrement:")
                
                HStack {
                    Text("1")
                    Image(systemName: isOneSelected ? "largecircle.fill.circle" : "circle")
                        .onTapGesture {
                            isOneSelected = true
                        }
                }
                
                HStack {
                    Text("0.5")
                    Image(systemName: !isOneSelected ? "largecircle.fill.circle" : "circle")
                        .onTapGesture {
                            isOneSelected = false
                        }
                }
            }
            
            List {
                ForEach($mealManager.members) { $member in
                    HStack {
                        Text(member.name)
                        
                        
                        Spacer() // Pushes the button and value to the right
                        
                        HStack {
                            // Minus button: Decreases meal count if it's greater than 0
                            let key = "\(day) - \(month)"
                            
                            
                            Button(action: {
                                if let currentMeals = member.meals[key], currentMeals > 0 {
                                    var count = currentMeals - (isOneSelected ? 1 : 0.5)
                                    if count < 0 { count = 0 }
                                    member.meals[key] = count
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            // Display current meal count in the middle
                            Text("Meals: \(String(format: "%0.1f", member.meals[key] ?? 0))")
                                .padding(.horizontal)
                            
                            
                            // Plus button: Increases meal count
                            Button(action: {
                                if let currentMeals = member.meals[key], currentMeals > 0 {
                                    member.meals[key] = currentMeals + (isOneSelected ? 1 : 0.5)
                                } else {
                                    member.meals[key] = isOneSelected ? 1 : 0.5
                                    
                                }
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .padding(.vertical, 8) // Adds some padding to each row
                }
            }
            
            Spacer()
            // Save Button
            Button(action: {
                Task {
                    isLoading = true
                    let result = await mealManager.updateAllMembersMeals()
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
        .navigationTitle("Add Meals")
    }
}

struct AddMealsView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealsView(mealManager: MealManager.shared)
    }
}
