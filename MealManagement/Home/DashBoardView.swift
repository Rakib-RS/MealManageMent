//
//  DashBoardView.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import SwiftUI

struct DashBoardView: View {
    @ObservedObject var mealManager = MealManager.shared
    
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            VStack {
                DashBoardSummaryView(summary: mealManager.summary)
                Spacer()
                DashBoardListView(mealManager: mealManager)
            }
            
        }
        .tabItem {
            Image(systemName: "house.fill")
            Text("Dashboard")
        }
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
