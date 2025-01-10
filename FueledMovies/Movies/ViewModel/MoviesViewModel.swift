//
//  MoviesViewModel.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/9/25.
//

import Foundation
import Combine

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movieList = [Movie]()
    @Published var showAlert = false
    
    func getMovies(filter: MovieFilter) async {
        do {
            let movieService = MovieService()
            movieList = try await movieService.getMovies(filter: filter)
        }
        catch {
            print("Failed to fetch moives with filter \(filter) \(error.localizedDescription)")
            showAlert = true
        }
    }
}
