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
                            .labelsHidden()

                        // Display the formatted date
                        Text("Selected Date: \(dateFormatter.string(from: date))")
                            .font(.headline)
                            .padding()
            
            Text("Day: \(day), Month: \(month)")
                            .font(.headline)
                            .padding()
            
            List {
                ForEach($mealManager.members) { $member in
                    HStack {
                        Text(member.name)
                        
                        
                        Spacer() // Pushes the button and value to the right
                        
                        HStack {
                            // Minus button: Decreases meal count if it's greater than 0
                            let key = "\(day-month)"
                            
                            
                            Button(action: {
                                if let currentMeals = member.meals[key], currentMeals > 0 {
                                        member.meals[key] = currentMeals - 1
                                    }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            // Display current meal count in the middle
                            Text("Meals: \(member.meals[key] ?? 0)")
                                .padding(.horizontal)
                            
                            // Plus button: Increases meal count
                            Button(action: {
                                if let currentMeals = member.meals[key], currentMeals > 0 {
                                        member.meals[key] = currentMeals + 1
                                } else {
                                    member.meals[key] = 1
                                    
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
                mealManager.prepareSummary()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 10)
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
