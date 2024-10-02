//
//  MealManager.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import Foundation
import Combine

class MealManager: ObservableObject {
    static let shared = MealManager()
    
    @Published var members: [Member]
    @Published var membersVm: [MemberViewModel] = []
    @Published var summary: Summary = Summary()
    @Published var currentMealRate: Double = 0.0
    
    private var totalBazar: Double = 0
    private var totalMeal: Double = 0
    private var password: String = "honda503"
    private var cancellables = Set<AnyCancellable>()
    
    private static let defaults = UserDefaults.standard
    private static let membersKey = "membersKey"
    
    private init() {
        if let members = MealManager.retrieveMembers() {
            self.members = members
//            members.forEach { member in
//                let memberVM = MemberViewModel(member: member, currentMealrate: $currentMealRate.eraseToAnyPublisher())
//                self.membersVm.append(memberVM)
//            }
        } else {
            self.members = []
        }
        
        //members = []
        prepareSummary()
        observeMembers()
    }
    
    func test() {
        members.append(.init(name: "Fuad", phoneNumber: "0123"))
        members.append(.init(name: "Amzad", phoneNumber: "0145"))
        
        let memberVM = MemberViewModel(member: members[0], currentMealrate: $currentMealRate.eraseToAnyPublisher())
        let memberVM1 = MemberViewModel(member: members[1], currentMealrate: $currentMealRate.eraseToAnyPublisher())
        membersVm.append(memberVM)
        membersVm.append(memberVM1)
        
    }
    
    private func prepareSummary() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.countMeals()
            
            self.summary = Summary()
            self.totalBazar = 0
            self.totalMeal = 0
            
            self.members.forEach { member in
                self.totalBazar = self.totalBazar + member.totalBazar
                self.totalMeal = self.totalMeal + member.totalMeal
            }
            
            currentMealRate = totalMeal > 0 ? totalBazar/Double(totalMeal) : 0
            print("current mealrate: \(currentMealRate)")
            
            summary.totalBazar = totalBazar
            summary.totalMeal = totalMeal
            summary.mealRate = currentMealRate
            
            // Update membersVm when members change
            self.membersVm = self.members.map { member in
                MemberViewModel(member: member, currentMealrate: self.$currentMealRate.eraseToAnyPublisher())
            }
        }
    }
    
    private func observeMembers() {
        $members.removeDuplicates().sink { [weak self] _ in
            print("[mealManager] Members updated")
            self?.prepareSummary()
        }.store(in: &cancellables)
    }
    
    private func countMeals() {
        let month = Calendar.current.component(.month, from: Date())
        members = members.map { member in
            var mealCount = 0.0
            
            for day in 1...31 {
                let key = "\(day) - \(month)"
                
                if let currentMeals = member.meals[key] {
                    mealCount += currentMeals
                }
            }
            
            var updatedMember = member
            updatedMember.totalMeal = mealCount
            return updatedMember
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
    
    func addMember(name: String, phoneNumber: String) {
        let member = Member(name: name, phoneNumber: phoneNumber)
        members.append(member)
        membersVm.append(MemberViewModel(member: member, currentMealrate: $currentMealRate.eraseToAnyPublisher()))
        
        saveInDefault()
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
    
    func clearMemeberData(password: String) -> Bool {
        if password != self.password {
            return false
        }
        
        for i in 0..<members.count {
            members[i].totalBazar = 0.0
            members[i].todayMeal = 0.0
            members[i].meals.removeAll()
            members[i].totalMeal = 0.0
        }
        
        prepareSummary()
        return true
    }
}
