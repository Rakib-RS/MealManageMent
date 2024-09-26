//
//  MembersView.swift
//  MealManagement
//
//  Created by Rakib on 22/9/24.
//

import Combine
import SwiftUI

struct MembersView: View {
    @ObservedObject var mealManager = MealManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.ignoresSafeArea()
                VStack {
                    List {
                        Section {
                            ForEach(mealManager.members) { member in
                                NavigationLink(destination:  {
                                    MembersDetailsView(member: member)
                                }, label: {
                                    Text(member.name)
                                })
                            }
                            
                        } header: {
                            Text("Members list")
                        }
                    }
                    
                    NavigationLink(destination: AddMemberView( mealManager: mealManager)) {
                        Text("Add member")
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
            Image(systemName: "person")
            Text("Members")
        }
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView()
    }
}
