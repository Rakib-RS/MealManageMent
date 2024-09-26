//
//  MealManager.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import Foundation

struct Summary {
    var totalBazar: Double = 0
    var totalMeal: Int = 0
    var mealRate: Double = 0
}


class MealManager: ObservableObject {
    static let shared = MealManager()
    
    @Published var members: [Member]
    @Published var summary: Summary = Summary()
    var currentMealRate: Double = 0
    
    private var totalBazar: Double = 0
    private var totalMeal: Int = 0
    
    private static let defaults = UserDefaults.standard
    private static let membersKey = "membersKey"
    
    private init() {
        if let members = MealManager.retrieveMembers() {
            self.members = members
        } else {
            self.members = []
        }
        
        prepareSummary()
    }
    
    func test() {
        members.append(.init(name: "Fuad", phoneNumber: "0123"))
        members.append(.init(name: "Amzad", phoneNumber: "0145"))
    }
    
    func prepareSummary() {
        countMeals()
        summary = Summary()
        totalBazar = 0
        totalMeal = 0
        
        members.forEach { member in
            totalBazar = totalBazar + member.totalBazar
            totalMeal = totalMeal + member.totalMeal
        }
        
        currentMealRate = totalBazar/Double(totalMeal)
        
        summary.totalBazar = totalBazar
        summary.totalMeal = totalMeal
        summary.mealRate = currentMealRate
    }
    
    private func countMeals() {
        let month = Calendar.current.component(.month, from: Date())
        for i in 0..<members.count {
            var mealCount = 0;
            let member = members[i]
            for j in 1...31 {
               let key = "\(j-month)"
                if let currentMeals = member.meals[key] {
                    mealCount = mealCount + currentMeals
                }
            }
            members[i].totalMeal = mealCount
        }
        
        saveInDefault()
    }
    
    private func saveInDefault() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(members)
            MealManager.defaults.set(data, forKey: MealManager.membersKey)
            print("[Manager] data saved successfully")
        } catch {
            print("[Manager] data saving error: \(error)")
        }
    }
    
    private static func retrieveMembers() -> [Member]? {
        guard let savedMembersData = defaults.data(forKey: membersKey) else {
            print("no data exist")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let members = try decoder.decode([Member].self, from: savedMembersData)
            
            return members
        } catch {
            print("data retrieve failure error: \(error)")
            return nil
        }
    }
    
    func addBazar(id: UUID, amount: Double) {
        members = members.map { member in
            if member.id == id {
                var updateMember = member
                updateMember.totalBazar = updateMember.totalBazar + amount
                return updateMember
            } else {
                return member
            }
        }
        
        saveInDefault()
    }
}
