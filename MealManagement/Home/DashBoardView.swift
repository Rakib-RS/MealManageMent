//
//  DashBoardView.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import SwiftUI

struct DashBoardView: View {
    @ObservedObject var mealManager = MealManager.shared
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            VStack {
                DashBoardSummaryView(summary: mealManager.summary)
                Spacer()
                DashBoardListView(mealManager: mealManager)
                ZStack {
                    
                }
            }
            
            if mealManager.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()  // Semi-transparent background
                    ProgressView("Fetching members...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)  // Make the spinner larger
                        .foregroundColor(.white)
                }
            }
            
        }
        .tabItem {
            Image(systemName: "house.fill")
            Text("Dashboard")
        }
        .onAppear {
            Task {
                await mealManager.fetchAllMembers()
            }
            
        }
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
