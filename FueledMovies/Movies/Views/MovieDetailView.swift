//
//  MovieDetailView.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import SwiftUI

struct MovieDetailView: View {
    
    @StateObject var viewModel: MovieItemViewModel
    
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieItemViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16.0) {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                //Replacing a view so lay them out on top of one another
                ZStack {
                    switch viewModel.imageDownloadState {
                    case .downloading:
                        ZStack {
                            Rectangle()
                                .fill(Color("BackgroundColor"))
                                .frame(height: 300)
                                .cornerRadius(8)
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                                .tint(.white)
                                .foregroundColor(.white)
                        }
                        .transition(.opacity)
                        
                    case .complete:
                        Image(uiImage: viewModel.movieImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(8)
                            .transition(.opacity)
                    case .failed:
                        Rectangle()
                            .fill(Color("BackgroundColor"))
                            .frame(height: 300)
                            .cornerRadius(8)
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.imageDownloadState)
                
                Text("Overview")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(viewModel.overview)
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .task {
                await viewModel.loadPosterImage()
            }
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie(id: 939243,
                                 adult: false,
                                 backdropPath: "",
                                 genreIds: [],
                                 originalLanguage: "",
                                 originalTitle: "Sonic the Hedgehog 3",
                                 overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.",
                                 popularity: 4115.631,
                                 posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg",
                                 releaseDate: "",
                                 title: "Sonic the Hedgehog 3",
                                 video: false,
                                 voteAverage: 7.6,
                                 voteCount: 443))
}
