//
//  GridView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct DateMemberMatrixView: View {
    @State var members: [Member]
    
    @State private var dates: [Date] = []
    
    // Format date for display
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack {
                // Column headers (dates)
                LazyHGrid(rows: [GridItem(.fixed(50))], alignment: .center) {
                    Text("Members")
                        .bold()
                        .frame(width: 100)
                        .background(Color.gray.opacity(0.3))
                    
                    ForEach(dates, id: \.self) { date in
                        Text(dateFormatter.string(from: date))
                            .bold()
                            .frame(width: 100)
                            .background(Color.gray.opacity(0.3))
                            .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
                
                // Matrix: Members as rows, Dates as columns
                ForEach(members) { member in
                    LazyHGrid(rows: [GridItem(.fixed(50))], alignment: .center) {
                        // Member name row header
                        Text(member.name)
                            .frame(width: 100)
                            .background(Color.gray.opacity(0.2))
                            .padding(.vertical, 4)
                        
                        // Each date's cell for this member
                        ForEach(dates, id: \.self) { date in
                            // You can replace this with actual data
                            
                            let day = Calendar.current.component(.day, from: date)
                            let month = Calendar.current.component(.month, from: date)
                            let key = "\(day-month)"
                            Text("\(member.meals[key] ?? 0)")
                                .frame(width: 100)
                                .background(Color.blue.opacity(0.2))
                                .padding(.vertical, 4)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            generateDates()
        }
        .navigationTitle("Members Meals")
    }
    
    // Generate sample dates for the matrix
    private func generateDates() {
        let calendar = Calendar.current
        let today = Date()
        
        // Get the start of the current month
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!

        // Calculate the number of days between the start of the month and today
        let numberOfDays = calendar.dateComponents([.day], from: startOfMonth, to: today).day ?? 0
        
        // Clear previous dates if necessary
        dates.removeAll()
        
        // Generate dates from the start of the month to today
        for i in 0...numberOfDays {
            if let newDate = calendar.date(byAdding: .day, value: i, to: startOfMonth) {
                dates.append(newDate)
            }
        }
    }

}

struct DateMemberMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        DateMemberMatrixView(members: MealManager.shared.members)
    }
}
