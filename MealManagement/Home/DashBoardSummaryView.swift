//
//  DashBoardSummaryView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct DashBoardSummaryView: View {
    var summary: Summary
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                HStack {
                    MonthPickerView()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                Group {
                    summaryRow(title: "Total Bazar:", value: currencyText(summary.totalBazar))
                    summaryRow(title: "Total Meal:", value: Text(String(format: "%0.1f", summary.totalMeal)))
                    summaryRow(title: "Current Meal Rate:", value: currencyText(summary.mealRate))
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    func summaryRow(title: String, value: Text) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            value
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)
        )
    }
    
    func currencyText(_ amount: Double) -> Text {
        Text(currency: amount, currencyCode: "BDT", locale: Locale(identifier: "en_BD"))
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
