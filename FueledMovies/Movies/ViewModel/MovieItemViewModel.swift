//
//  MovieItemViewModel.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/10/25.
//

import Foundation
import Combine
import UIKit

@MainActor
class MovieItemViewModel: ObservableObject {
    enum ImageDownloadState {
        case downloading
        case complete
        case failed
    }
    
    @Published var movieImage: UIImage = UIImage() //maybe find some defautl
    @Published var imageDownloadState: ImageDownloadState = .downloading
    private let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    var title: String {
        return movie.title
    }
    
    func loadImage() async {
        let movieService = MovieService()
        do {
            movieImage = try await movieService.getLogoImage(for: movie)
            imageDownloadState = .complete
        }
        catch {
            print("Failed to download image with error: \(error.localizedDescription)")
            imageDownloadState = .failed
        }
    }
}
