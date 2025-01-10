//
//  MovieService.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import Foundation

extension MovieFilter {
    var route: String {
        switch self {
        case .popular: "3/movie/popular"
        case .topRated: "3/movie/top_rated"
        case .upcoming: "3/movie/upcoming"
        }
    }
}

class MovieService: FueledService {
    func getMovies(filter: MovieFilter) async throws -> [Movie] {
        let asyncSession = AsyncSession(sessionConfiguration: createSessionConfiguration())
        let response:MovieListResponse = try await asyncSession.get(path: filter.route,
                                                                    parameters: nil,
                                                                    dateFormatters: [])
        return response.results
    }
}
