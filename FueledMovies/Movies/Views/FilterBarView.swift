//
//  FilterBarView.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/10/25.
//

import Foundation
import SwiftUI

struct FilterBarView: View {
    @Binding var selected: MovieFilter
    var body: some View {
        HStack {
            FilterButton(title: "Most Popular",
                         isSelected: selected == .popular) {
                selected = .popular
            }
            FilterButton(title: "Top Rated",
                         isSelected: selected == .topRated) {
                selected = .topRated
            }
            FilterButton(title: "Upcoming",
                         isSelected: selected == .upcoming) {
                selected = .upcoming
            }
        }
        .padding()
    }
}

struct FilterButton: View {
    var title: String
    var isSelected: Bool
    var onTapped:() -> Void
    private let baseColor = Color(red: 18 / 255,
                                  green: 34 / 255,
                                  blue: 46 / 255)
    var body: some View {
        Button(action: onTapped) {
            Text(title)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(isSelected ? .white : baseColor)
                .foregroundColor(isSelected ? baseColor : .white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1))
        }
    }
}
