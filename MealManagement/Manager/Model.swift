//
//  Model.swift
//  MealManagement
//
//  Created by Rakib on 24/9/24.
//

import Foundation

struct Member: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var todayMeal: Double = 0
    var totalMeal: Double = 0
    var totalBazar: Double = 0
    var totalMealCost: Double  = 0
    var meals: [String: Double] = [:] //key: day-month
    var balance: Double { return totalBazar - totalMealCost }
    
    static func ==(lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.totalBazar == rhs.totalBazar &&
        lhs.totalMeal == rhs.totalMeal &&
        lhs.meals == rhs.meals &&
        lhs.balance == rhs.balance &&
        lhs.totalMealCost == rhs.totalMealCost
    }
}

struct Summary {
    var totalBazar: Double = 0
    var totalMeal: Double = 0
    var mealRate: Double = 0
}
