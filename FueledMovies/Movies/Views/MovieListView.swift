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


#Preview {
    MovieListView { selected in
        print("Selected movie \(selected.title)")
    }
}


