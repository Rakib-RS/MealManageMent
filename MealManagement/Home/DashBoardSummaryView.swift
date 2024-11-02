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
                    MonthPickerView()
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
                    Text(currency: summary.totalBazar, currencyCode: "BDT", locale: Locale(identifier: "en_BD"))
                        .font(.title)
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
                    Text(String(format: "%0.1f", summary.totalMeal))
                        .font(.title2)
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
                    Text(currency: summary.mealRate, currencyCode: "BDT", locale: Locale(identifier: "en_BD"))
                        .font(.title)
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

extension Text {
    init(currency: Double, currencyCode: String = "BDT", locale: Locale = Locale.current) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let formattedString = formatter.string(from: NSNumber(value: currency)) ?? ""
        self.init(formattedString)
    }
}
