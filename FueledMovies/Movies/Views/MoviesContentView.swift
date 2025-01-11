//
//  MovieTabView.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/6/25.
//

import SwiftUI
import Combine

enum Page: Identifiable, Hashable {
    case movieDetail(Movie)
    
    var id: String {
        switch self {
        case .movieDetail(_): "movieDetail"
        }
    }
}

struct MoviesContentView: View {
    @State private var path = NavigationPath()
    
    init() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            
        let appearance = UINavigationBarAppearance()
        
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white]
        appearance.backButtonAppearance = backItemAppearance
        
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white,
                                                                           renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BackgroundColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        NavigationStack(path: $path){
            movieListView()
                .navigationDestination(for: Page.self) { page in
                    if case .movieDetail(let movie) = page {
                        MovieDetailView(movie: movie)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func movieListView() -> MovieListView {
        let view = MovieListView { selectedMovie in
            path.append(Page.movieDetail(selectedMovie))
        }
        return view
    }
}

#Preview {
    MoviesContentView()
}
