//
//  AddTransactionView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var mealManager = MealManager.shared
    
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            NavigationView {
                VStack {
                    NavigationLink(destination: AddMealsView(mealManager: mealManager)) {
                        Text("Add Meals")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    NavigationLink(destination: AddBazarView(mealManager: mealManager)) {
                        Text("Add Bazar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    NavigationLink(destination: DateMemberMatrixView(members: mealManager.members)) {
                        Text("Excel View")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
        }
        .tabItem {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 25))
                Text("Add")
            }
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
