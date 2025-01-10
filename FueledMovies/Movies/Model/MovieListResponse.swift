//
//  MovieListResponse.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import Foundation

// MARK: - MovieListResponse
struct MovieListResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

// MARK: - Result
struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let adult: Bool
    let backdropPath: String
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}
