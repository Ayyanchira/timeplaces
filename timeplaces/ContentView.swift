//
//  ContentView.swift
//  timeplaces
//
//  Created by Akshay Ayyanchira on 2/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTime = Date()
    @State private var navigateToDetail = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Find out which cities around the world are sharing your chosen time right now!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                Spacer()
                
                DatePicker("Select Time",
                          selection: $selectedTime,
                          displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                Button(action: {
                    navigateToDetail = true
                }) {
                    Text("Find Locations")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Time Explorer")
            .navigationDestination(isPresented: $navigateToDetail) {
                CountriesView(selectedTime: selectedTime)
            }
        }
    }
}

#Preview {
    ContentView()
}
