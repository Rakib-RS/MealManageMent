//
//  MealManager.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import FirebaseFirestore
import Foundation
import Combine

class MealManager: ObservableObject {
    static let shared = MealManager()
    
    @Published var members: [Member]
    @Published var membersVm: [MemberViewModel] = []
    @Published var summary: Summary = Summary()
    @Published var currentMealRate: Double = 0.0
    @Published var isLoading: Bool = false
    
    private var membersPublisher = PassthroughSubject<[Member], Never>()
    
    private var totalBazar: Double = 0
    private var totalMeal: Double = 0
    private var password: String = "honda503"
    private var cancellables = Set<AnyCancellable>()
    
    private let db = Firestore.firestore()
    private let membersCollection = Firestore.firestore().collection("members")
    
    private static let defaults = UserDefaults.standard
    private static let membersKey = "membersKey"
    
    private var selectedMonthIndex = Calendar.current.component(.month, from: Date())
    
    private init() {
        members = []
        startObserving()
    }
    
    private func startObserving() {
        membersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] members in
                print("[MealManager] fetched members: \(members)")
                
                self?.members = members
                self?.prepareSummary()
            }.store(in: &cancellables)
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
                let key = "\(day) - \(selectedMonthIndex)"
                
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
    
    func updateMonth(index: Int) {
        selectedMonthIndex = index
        Task {
            isLoading = true
            await fetchAllMembers()
            isLoading = false
        }
    }
    
    func updateMemebr(member: Member) {
        let membersCollection = db.collection("members")
        membersCollection.document(member.id.uuidString).updateData(member.toDictionary()) { error in
            if let error {
                print("error updating member: \(error)")
            } else {
                print("member updated successfully")
            }
        }
    }
}

//server call
extension MealManager {
    func addMember(name: String, phoneNumber: String) async -> Bool {
        let member = Member(name: name, phoneNumber: phoneNumber)
        
        return await withCheckedContinuation { continuation in
            membersCollection.document(member.id.uuidString).setData(member.toDictionary()) { error in
                if let error {
                    print("[MealManager] add Member error: \(error)")
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                    self.members.append(member)
                    self.membersVm.append(MemberViewModel(member: member, currentMealrate: self.$currentMealRate.eraseToAnyPublisher()))
                }
            }
        }
    }
    
    func addBazar(id: UUID, amount: Double) async -> Bool {
        return await withCheckedContinuation { continuation in
            membersCollection.document(id.uuidString).updateData(["totalBazar": FieldValue.increment(amount)]) { error in
                if let error {
                    print("[MealManager] add Bazar error: \(error)")
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func updateAllMembersMeals() async -> Bool {
        return await withCheckedContinuation { continuation in
            Task {
                await withTaskGroup(of: Bool.self) { group in
                    var allUpdateSuccess: Bool = true
                    
                    members.forEach { member in
                        group.addTask {
                            return await self.updateMeals(member: member)
                        }
                    }
                    
                    for await result in group {
                        if !result { allUpdateSuccess = false }
                    }
                    continuation.resume(returning: allUpdateSuccess)
                }
            }
        }
    }
    
    private func updateMeals(member: Member) async -> Bool {
        return await withCheckedContinuation { continuation in
            membersCollection.document(member.id.uuidString).updateData(
                ["meals": member.meals]
            ) { error in
                if let error {
                    print("[MealManager] update meals for\(member.id.uuidString) error: \(error)")
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func clearMemeberData(password: String) async -> Bool {
        if password != self.password {
            return false
        }
        
        for i in 0..<members.count {
            members[i].totalBazar = 0.0
            members[i].todayMeal = 0.0
            members[i].meals.removeAll()
            members[i].totalMeal = 0.0
        }
        
        return await withCheckedContinuation { continuation in
            Task {
                await withTaskGroup(of: Bool.self) { group in
                    var isResetAll: Bool = true
                    
                    members.forEach { member in
                        group.addTask {
                            await self.resetMember(member: member)
                        }
                    }
                    
                    for await result in group {
                        if !result {
                            isResetAll = false
                        }
                    }
                    continuation.resume(returning: isResetAll)
                }
            }
        }
    }
    
    private func resetMember(member: Member) async -> Bool {
        return await withCheckedContinuation { continuation in
            membersCollection.document(member.id.uuidString).updateData(member.toDictionary()) { error in
                    if let error {
                    print("[MealManager] reset member error: \(error)")
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func fetchAllMembers() async {
        isLoading = true
        let fetchedMembers: [Member] = await withCheckedContinuation { continuation in
            membersCollection.getDocuments { (snapshot, error) in
                if let error {
                    print("Error fetching members: \(error)")
                    continuation.resume(returning: [])
                } else {
                    guard let documents = snapshot?.documents else {
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let members: [Member] = documents.compactMap { document in
                        let data = document.data()
                        
                        let idString = data["id"] as? String ?? UUID().uuidString
                        let id = UUID(uuidString: idString) ?? UUID()
                        let name = data["name"] as? String ?? "Unknown"
                        let phoneNumber = data["phoneNumber"] as? String ?? "No Phone"
                        let todayMeal = data["todayMeal"] as? Double ?? 0.0
                        let totalMeal = data["totalMeal"] as? Double ?? 0.0
                        let totalBazar = data["totalBazar"] as? Double ?? 0.0
                        let totalMealCost = data["totalMealCost"] as? Double ?? 0.0
                        let meals = data["meals"] as? [String: Double] ?? [:]
                        
                        return Member(
                            id: id,
                            name: name,
                            phoneNumber: phoneNumber,
                            todayMeal: todayMeal,
                            totalMeal: totalMeal,
                            totalBazar: totalBazar,
                            totalMealCost: totalMealCost,
                            meals: meals
                        )
                    }
                    self.isLoading = false
                    continuation.resume(returning: members)
                }
            }
        }
        membersPublisher.send(fetchedMembers)
    }
    
}
