//
//  MealManagementApp.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import FirebaseCore
import SwiftUI

@main
struct MealManagementApp: App {
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
