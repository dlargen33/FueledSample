//
//  FueledMoviesApp.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/6/25.
//

import SwiftUI

/*
 Application class.  Manages the application start up.  Here a configuration is downloaded that is needed to make request to
 The Movie DB.  
 */
@main
struct FueledMoviesApp: App {
    let persistenceController = PersistenceController.shared
    
    enum LoadingState {
        case completed
        case loading
        case error
    }

    @State private var showAlert = false
    @State private var loadingState = LoadingState.loading
    
    let configService = ConfigurationService()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch loadingState {
                case .completed:
                    MoviesContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                case .loading:
                    LoadingView()
                case .error:
                    ErrorView()
                }
            }
            .task {
                await loadConfig()
            }
            .alert("Error", isPresented: $showAlert) {
                Button("Try Again") {
                  Task {
                      await loadConfig()
                  }
                }
                Button("Cancel", role: .cancel) {
                    withAnimation {loadingState = .error}
                }
              } message: {
                  Text("Failed to load configuration data. Please try again.")
              }
        }
    }
    
    private func loadConfig() async {
        do {
            try await configService.getConfig()
            withAnimation {loadingState = .completed }
        }
        catch {
            showAlert = true
            print("Something bad happend \(error)")
        }
    }
}

struct ErrorView: View {
    var body: some View {
        Text("Application failed to initialize.  Try restarting the app")
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .tint(.white)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .ignoresSafeArea()
    }
}
