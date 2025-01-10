//
//  MovieListView.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import SwiftUI

struct MovieListView: View {
    @State private var selectedFilter: MovieFilter = .popular
    @StateObject private var viewModel: MoviesViewModel = MoviesViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 12 / 255, green: 26 / 255, blue: 38 / 255),
                    Color(red: 18 / 255, green: 34 / 255, blue: 46 / 255),
                    Color(red: 24 / 255, green: 40 / 255, blue: 54 / 255)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                FilterBarView(selected: $selectedFilter)
                MoviesView(viewModel: viewModel)
                Spacer()
            }
        }
        .navigationBarTitle("Movies")
        .task {
            await viewModel.getMovies(filter: selectedFilter)
        }
        .onChange(of: selectedFilter) {
            Task {
                await viewModel.getMovies(filter: selectedFilter)
            }
        }
    }
}

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
                .padding(.horizontal, 15)
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

struct MovieItemView: View {
    let movie: Movie
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 150)
                    .cornerRadius(8)
                
                Text(movie.title)
                    .font(.system(size: 14,
                                  weight: .semibold,
                                  design: .rounded))
                    .minimumScaleFactor(0.8)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .top)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 100)
        .padding(.bottom, 5)
    }
}

#Preview {
    MovieListView()
}


struct MoviesView: View {
    @ObservedObject var viewModel: MoviesViewModel
    
    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.movieList) { movie in
                    MovieItemView(movie: movie) {
                        print("Button with movie \(movie.title) touched")
                    }
                }
            }
            .padding()
        }
    }
}
