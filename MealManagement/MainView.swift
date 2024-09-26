//
//  ContentView.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DashBoardView()
            MembersView()
            AddTransactionView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

