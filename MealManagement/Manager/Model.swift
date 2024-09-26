//
//  Model.swift
//  MealManagement
//
//  Created by Rakib on 24/9/24.
//

import Foundation

struct Member: Identifiable, Codable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var todayMeal: Int = 0
    var totalMeal: Int = 0
    var totalBazar: Double = 0
    var totalMealCost: Double { return MealManager.shared.currentMealRate * Double(totalMeal) }
    var meals: [String: Int] = [:] //key: day-month
    var balance: Double { return totalBazar - totalMealCost }
}
