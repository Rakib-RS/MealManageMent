//
//  DasBoardListView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct DashBoardListView: View {
    @Binding var members: [Member]
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(members) { member in
                        GeometryReader { geometry in
                            HStack(spacing: 10) {
                                Text(member.name)
                                    .frame(width: geometry.size.width * 0.20, alignment: .leading)
                                    .font(.system(size: 14))
                                
                                Text("\(member.totalMeal)")
                                    .frame(width: geometry.size.width * 0.10, alignment: .trailing)
                                    .font(.system(size: 14))
                                
                                Text(String(format: "%.02f", member.totalBazar))
                                    .frame(width: geometry.size.width * 0.25, alignment: .trailing)
                                    .font(.system(size: 14))
                                
                                Text(String(format: "%.02f", member.totalMealCost))
                                    .frame(width: geometry.size.width * 0.25, alignment: .trailing)
                                    .font(.system(size: 14))
                                
                                VStack {
                                    if member.balance >= 0 {
                                        Text(String(format: "%.02f", member.balance))
                                            .foregroundColor(.green)
                                            .frame(width: geometry.size.width * 0.20, alignment: .trailing)
                                            .font(.system(size: 14))
                                    } else {
                                        Text(String(format: "%.02f", member.balance))
                                            .foregroundColor(.red)
                                            .frame(width: geometry.size.width * 0.20, alignment: .trailing)
                                            .font(.system(size: 14))
                                    }
                                }
                            }
                            .frame(height: 20) // Adjust the row height as needed
                        }
                        .frame(height: 20) // Ensure consistent row height
                    }
                }
                //.listRowInsets(EdgeInsets()) // Remove default padding around rows
                header: {
                    HStack(alignment: .center, spacing: 10) {
                        GeometryReader { geometry in
                            HStack {
                                Text("Name")
                                    .frame(width: geometry.size.width * 0.15, alignment: .leading)
                                Text("Meal")
                                    .frame(width: geometry.size.width * 0.15, alignment: .trailing)
                                Text("Bazar")
                                    .frame(width: geometry.size.width * 0.25, alignment: .trailing)
                                Text("Meal Cost")
                                    .frame(width: geometry.size.width * 0.25, alignment: .trailing)
                                Text("Balance")
                                    .frame(width: geometry.size.width * 0.20, alignment: .trailing)
                            }
                        }
                        .frame(height: 30) // Adjust header height as needed
                    }
                }
            }
            .listRowInsets(EdgeInsets()) // Remove default padding around rows
            
        }
    }
}

struct DashBoardListView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardListView(members: .constant([Member(name: "John Doe", phoneNumber: "123456789")]))
    }
}
