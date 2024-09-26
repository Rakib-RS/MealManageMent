//
//  DashBoardSummaryView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct DashBoardSummaryView: View {
    var summary: Summary
    
    var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: Date()) // Current date
    }
    
    var body: some View {
        ZStack {
            //Color.gray.ignoresSafeArea()
            VStack {
                HStack {
                    Text("Date:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(formattedDate)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                //.background(Color.white)
                .cornerRadius(10)
                //.shadow(radius: 5)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("Total Bazar:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(summary.totalBazar.description)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                //.background(Color.white)
                .cornerRadius(10)
                //.shadow(radius: 5)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("Total Meal:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(summary.totalMeal.description)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                //.background(Color.white)
                .cornerRadius(10)
                //.shadow(radius: 5)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("Current Meal Rate:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(summary.mealRate.description)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                //.background(Color.white)
                .cornerRadius(10)
                //.shadow(radius: 5)
                .padding(.horizontal, 20)
                
                
            }
        }
    }
}

struct DashBoardSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardSummaryView(summary: Summary())
    }
}
