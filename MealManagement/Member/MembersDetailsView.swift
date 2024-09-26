//
//  MembersDetailsView.swift
//  MealManagement
//
//  Created by Rakib on 23/9/24.
//

import SwiftUI

struct MembersDetailsView: View {
    var member: Member
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea() // Background color
            
            VStack(spacing: 20) {
                // Header Image or Icon
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                // Name
                Text(member.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Phone Number Section
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text(member.phoneNumber)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("Today's Meal:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(member.todayMeal.description)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.background(Color.white)
                    .cornerRadius(10)
                    //.shadow(radius: 5)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("Total Meal:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(member.totalMeal.description)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.background(Color.white)
                    .cornerRadius(10)
                    //.shadow(radius: 5)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("Total Meal Cost:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(member.totalMealCost.description)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.background(Color.white)
                    .cornerRadius(10)
                    //.shadow(radius: 5)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("Total Bazar:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(member.totalBazar.description)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.background(Color.white)
                    .cornerRadius(10)
                    //.shadow(radius: 5)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("Current Balance:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(member.balance.description)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.background(Color.white)
                    .cornerRadius(10)
                    //.shadow(radius: 5)
                    .padding(.horizontal, 20)
                    
                    
                }
                //                .padding()
                //                .frame(maxWidth: .infinity, alignment: .leading)
                //                .background(Color.white)
                //                .cornerRadius(10)
                //                .shadow(radius: 5)
                //                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationTitle("Member Details")
    }
}


struct MembersDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MembersDetailsView(member: Member(name: "John Doe", phoneNumber: "123-456-7890"))
    }
}

