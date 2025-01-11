//
//  MovieService.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import Foundation
import UIKit

extension MovieFilter {
    var route: String {
        switch self {
        case .popular: "3/movie/popular"
        case .topRated: "3/movie/top_rated"
        case .upcoming: "3/movie/upcoming"
        }
    }
}


enum MovieServiceError: Error {
    case missingConfiguration
    case missingUrl
    case invalidImageData
}

class MovieService: FueledService {
    func getMovies(filter: MovieFilter) async throws -> [Movie] {
        let asyncSession = AsyncSession(sessionConfiguration: createSessionConfiguration())
        let response:MovieListResponse = try await asyncSession.get(path: filter.route,
                                                                    parameters: nil,
                                                                    dateFormatters: [])
        return response.results
    }
    
    func getLogoImage(for movie: Movie) async throws -> UIImage {
        return try await getMovieImage(for: movie, size: "w154")
    }
    
    func getPosterImage(for movie: Movie) async throws -> UIImage {
        return try await getMovieImage(for: movie, size: "w342")
    }
    
    private func getMovieImage(for movie: Movie, size: String) async throws -> UIImage {
        
        //check to see if we have a cached version
        if let cachedData = ImageRepository.shared.getImageData(movieId: movie.id, size: size),
           let cachedImage = UIImage(data:cachedData) {
            print("MovieService.getMovieImage cache hit")
            return cachedImage
        }
        
        guard let config = ConfigurationRepository.shared.getConfiguration() else {
            throw MovieServiceError.missingConfiguration
        }
        guard let baseUrl = URL(string: config.images.secureBaseUrl) else {
            throw MovieServiceError.missingUrl
        }

        let route = baseUrl.appendingPathComponent(size)
            .appendingPathComponent(movie.posterPath)
            .absoluteString
        
        let asyncSession = AsyncSession(sessionConfiguration: createSessionConfiguration())
        let data = try await asyncSession.download(route)
    
        guard let image = UIImage(data: data) else {
            throw MovieServiceError.invalidImageData
        }
        
        //image data is good up to this point.  Cache it
        ImageRepository.shared.addImageData(movieId: movie.id,
                                            size: size,
                                            data: data )
        
        return image
    }
}
