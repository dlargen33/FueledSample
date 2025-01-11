# Fueled Movies: A Sample iOS Application
## Overview
- This sample application leverages The Movie Database (TMDB) API to fetch a list of movie titles along with their corresponding images. The movies are displayed in a grid layout, and selecting a movie navigates the user to a detailed screen with additional information about the selected title.

The FueledMovies application demonstrates the following key concepts:
- UI Composition: Built using SwiftUI.
- Data Persistence: Utilizes CoreData to manage persistent storage, caching configuration data and movie images after they are retrieved.
- Networking Integration: Implements REST API communication with a custom AsyncSession class using Swift concurrency.

Application Overview
1. App Initialization (FueledMoviesApp.swift)
 - Manages the application startup.
 - Downloads necessary configuration for API requests.
 - Implements a LoadingState to handle UI transitions (loading, completed, error).
   
2. Movie Content (MovieContentView.swift)
- Sets up the navigation stack.
- Creates and displays a collection of movies.  This is encapsulate by MovieListView (MoviesView.swift)
- Each movie is presented by MovieItemView (MovieItemView.swift).  A movie item is represented by a movie poster imaged and a title.
- nteracting with a MovieItem will navigate the user to the MovieDetailView (MovieDetailView.swift). Navigation is achieved by pushing a view onto the navigation stack

3. Networking (AsyncSession.swift)
- Provides a framework for making GET requests and downloading binary data.
- Utilizes Swift concurrency (async/await) for clean, asynchronous operations.
- Offers extensibility for additional HTTP methods (e.g., POST, DELETE).
- Includes customizable session configurations and error handling.

4. Service Layer
- Services provide functionality related to the domain they are abstracting.
- ConfigurationService (ConfigurationService.swift) Requests configuration data from TMDB API and persists it to Core Data to be retrieved as needed
- MovieService (MovieService.swift) Provides functionality to request a list of movies and download and cache poster images for a movie.
  
5. Repository Layer
- Repositories provided access to data store in Core Data.  They implement the logic of converting model objects to an from Core Data Entities.  A design goal was not to expose underlying "backing" to the layers above.
- ConfigurationRepository (ConfigurationRepository.swift) provides operations to add and fetch the current configuration from Core Data.
- ImageReposity (ImageRespository.swift) provides operation to add and fetch image data from Core Data

## What to Look For
- MVVM Architecture: The project follows the Model-View-ViewModel (MVVM) design pattern, ensuring a clear separation of concerns. The ViewModel layer handles business logic and state management, making the SwiftUI views simpler and more focused on UI composition.
- SwiftUI Integration: The app demonstrates seamless integration of SwiftUI with MVVM, leveraging features like data binding and environment injection to create a reactive and maintainable UI.
- Service Layer (Domains) and ViewModel Synergy: The ViewModel interacts with Services, ensuring efficient caching and retrieval of configuration and movie data.
  
  
