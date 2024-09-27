//
//  ToastView.swift
//  MealManagement
//
//  Created by Rakib on 28/9/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    // Parameters for the toast
    let message: String
    let duration: TimeInterval
    
    // State for showing the toast
    @Binding var isShowing: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content // Main content
            if isShowing {
                VStack {
                    Spacer() // Push the toast to the bottom
                    
                    Text(message)
                        .font(.body)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: isShowing)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        isShowing = false // Hide the toast after the duration
                    }
                }
            }
        }
    }
}

extension View {
    // Custom modifier to show the toast
    func toast(message: String, isShowing: Binding<Bool>, duration: TimeInterval = 2.0) -> some View {
        self.modifier(ToastModifier(message: message, duration: duration, isShowing: isShowing))
    }
}

struct ToastExampleView: View {
    @State private var showToast = false
    
    var body: some View {
        VStack {
            Button("Show Toast") {
                showToast = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .toast(message: "This is a toast message!", isShowing: $showToast)
    }
}

struct ToastExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ToastExampleView()
    }
}

