//
//  MoviesView.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/10/25.
//

import Foundation
import SwiftUI
/*
 Displays a list of movies based on what filter is selected. MoviesViewModel manages the movies.
 It is a ObserverdObject becasue the containing view houses the filter bar.  When a filter is selected
 it triggers a call to fetch the appropriate titles.
 */
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

/*
 An item to show in the list.  MovieItemVieModel manages the item and also
 provides the ability to fetch the movie poster to display
 */
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
                //TODO figure out how to pull this out. This same approach is used on the MovieDetail screen
                ZStack {
                    switch viewModel.imageDownloadState {
                    case .downloading:
                        ZStack {
                            Rectangle()
                                .fill(Color("BackgroundColor"))
                                .frame(height: 150)
                                .cornerRadius(8)
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.75)
                                .tint(.white)
                                .foregroundColor(.white)
                        }
                        .transition(.opacity)
                        
                    case .complete:
                        Image(uiImage: viewModel.movieImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                            .transition(.opacity)
                    case .failed:
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 150)
                            .cornerRadius(8)
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.imageDownloadState)
                
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
            await viewModel.loadLogoImage()
        }
    }
}
