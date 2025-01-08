//
//  FueledMoviesApp.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/6/25.
//

import SwiftUI

@main
struct FueledMoviesApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingView()
                }
                else {
                    MoviesContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
            .onAppear() {
                loadConfig()
            }
        }
    }
    
    private func loadConfig(){
        DispatchQueue.main.asyncAfter(deadline: (.now() + 3)) {
            withAnimation {
                isLoading = false
            }
        }
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
