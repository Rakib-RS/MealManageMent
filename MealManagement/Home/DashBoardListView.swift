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
                        HStack(spacing: 5) {
                            Text(member.name)
                                .frame(width: 50, alignment: .leading)
                                .font(.system(size: 14, weight: .semibold))
                                .lineLimit(2)
                            
                            Text(String(format: "%0.1f", member.totalMeal))
                                .frame(width: 30, alignment: .trailing)
                                .font(.system(size: 14))
                            
                            Text(String(format: "%0.1f", member.totalBazar))
                                .frame(width: 70, alignment: .trailing)
                                .font(.system(size: 14))
                            
                            Text(String(format: "%0.1f", member.totalMealCost))
                                .frame(width: 70, alignment: .trailing)
                                .font(.system(size: 14))
                            
                            Text(String(format: "%0.1f", member.balance))
                                .frame(width: 70, alignment: .trailing)
                                .font(.system(size: 14))
                                .foregroundStyle( member.balance >= 0 ? Color.green : Color.red)
                            
                        }
                    }
                }
                header: {
                    HStack(alignment: .center, spacing: 5) {
                        Text("Name")
                            .frame(width: 30, alignment: .leading)
                            .font(.system(size: 14, weight: .semibold))
                            .lineLimit(2)
                        
                        Text("Meals")
                            .frame(width: 70, alignment: .trailing)
                            .font(.system(size: 14))
                        
                        Text("Bazar")
                            .frame(width: 70, alignment: .trailing)
                            .font(.system(size: 14))
                        
                        Text("Costs")
                            .frame(width: 70, alignment: .trailing)
                            .font(.system(size: 14))
                        
                        Text("Balance")
                            .frame(width: 70, alignment: .trailing)
                            .font(.system(size: 14))
                        
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
