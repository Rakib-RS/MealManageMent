//
//  MonthPickerView.swift
//  MealManagement
//
//  Created by Rakib on 1/11/24.
//

import SwiftUI

struct MonthPickerView: View {
    // Get the current month as a 1-based index (1 for January, 2 for February, etc.)
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date())
    
    private let months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Selected Month: ")
                    .padding()
                
                Picker("Select Month", selection: $selectedMonthIndex) {
                    ForEach(1...months.count, id: \.self) { index in
                        Text(months[index - 1]).tag(index)
                    }
                }
            }
            .pickerStyle(.menu)
            .padding()
            .onChange(of: selectedMonthIndex) { newIndex in
                MealManager.shared.updateMonth(index: newIndex)
            }
        }
    }
}

struct MonthPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MonthPickerView()
    }
}
