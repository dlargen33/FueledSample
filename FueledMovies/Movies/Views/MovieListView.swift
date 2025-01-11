//
//  MovieListView.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import SwiftUI
import Combine

struct MovieListView: View {
    @State private var selectedFilter: MovieFilter = .popular
    @StateObject private var viewModel: MoviesViewModel = MoviesViewModel()
    var onMovieSelected: (Movie) -> ()
    
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
                MoviesView(viewModel: viewModel) { selectedMovie in
                    print("Selected Movie \(selectedMovie.title)")
                    onMovieSelected(selectedMovie)
                }
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
    
    @StateObject private var viewModel: MovieItemViewModel
    let action: () -> Void
    
    init(movie: Movie, action: @escaping () -> Void ) {
        _viewModel = StateObject(wrappedValue: MovieItemViewModel(movie: movie))
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                switch viewModel.imageDownloadState {
                case .downloading:
                    ZStack {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 150)
                            .cornerRadius(8)
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(0.75)
                            .tint(.white)
                            .foregroundColor(.white)
                    }
                   
                case .complete:
                    Image(uiImage: viewModel.movieImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(8)
                case .failed:
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                
                Text(viewModel.title)
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
        .task {
            await viewModel.loadImage()
        }
    }
}

#Preview {
    MovieListView { selected in
        print("Selected movie \(selected.title)")
    }
}

struct MoviesView: View {
    @ObservedObject var viewModel: MoviesViewModel
    var onMovieSelected: (Movie) -> Void
    
    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.movieList) { movie in
                    MovieItemView(movie: movie) {
                        onMovieSelected(movie)
                    }
                }
            }
            .padding()
        }
    }
}
