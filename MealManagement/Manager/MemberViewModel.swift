//
//  MemberViewModel.swift
//  MealManagement
//
//  Created by Rakib on 2/10/24.
//
import Combine
import Foundation


class MemberViewModel: ObservableObject, Identifiable {
    var id: UUID
    @Published var member: Member
    
    private var currentMealrate: AnyPublisher<Double, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(member: Member, currentMealrate: AnyPublisher<Double, Never>) {
        self.member = member
        self.id = member.id
        self.currentMealrate = currentMealrate
        observeMealrate()
    }
    
    private func observeMealrate() {
        currentMealrate.sink { result in
            print("[MemberVM] Current mealrate: \(result)")
            self.member.totalMealCost = self.member.totalMeal * result
        }.store(in: &cancellables)
    }
}
