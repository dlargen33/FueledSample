//
//  MovieListView.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import SwiftUI

enum MovieFilter {
    case popular, topRated, upcoming
}

struct MovieListView: View {
    
    @State private var selectedFilter: MovieFilter = .popular
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 12 / 255, green: 26 / 255, blue: 38 / 255),  // Darker shade
                    Color(red: 18 / 255, green: 34 / 255, blue: 46 / 255),  // Base color
                    Color(red: 24 / 255, green: 40 / 255, blue: 54 / 255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                FilterBarView(selectedFilter: $selectedFilter)
                Text("Movie List")
                Spacer()
            }
        }
        .navigationBarTitle("Users")
    }
}

#Preview {
    MovieListView()
}

struct FilterBarView: View {
    @Binding var selectedFilter: MovieFilter
    
    var body: some View {
        HStack {
            FilterButton(title: "Most Popular", isSelected: selectedFilter == .popular) {
                selectedFilter = .popular
            }
            FilterButton(title: "Top Rated", isSelected: selectedFilter == .topRated) {
                selectedFilter = .topRated
            }
            FilterButton(title: "Upcoming", isSelected: selectedFilter == .upcoming) {
                selectedFilter = .upcoming
            }
        }
        .padding()
    }
}

struct FilterButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    private let baseColor = Color(red: 18 / 255,
                                  green: 34 / 255,
                                  blue: 46 / 255)
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .white : baseColor)
                .foregroundColor(isSelected ? baseColor : .white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
    }
}

