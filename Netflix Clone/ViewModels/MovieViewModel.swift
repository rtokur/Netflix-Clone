//
//  MovieViewModel.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation
@MainActor

class MovieViewModel: NSObject {
    // MARK: - List of movies to be displayed.
    var movies: [Movie] = [] {
        didSet {
            delegate?.moviesDidUpdate(movies: movies)
        }
    }
    var topRated: [Movie] = [] {
        didSet {
            delegate?.moviesDidUpdate(movies: topRated)
        }
    }
    // MARK: - List of genres to be used for filtering and displaying.
    var genres: [Genre] = [] {
        didSet {
            delegate?.genresDidUpdate(genres: genres)
        }
    }
    // MARK: - Boolean flag indicating whether data is being loaded.
    var isLoading : Bool = false {
        didSet {
            delegate?.isLoadingDidChange(isLoading: isLoading)
        }
    }
    // MARK: - Error message, if any error occurs during data fetching or processing.
    var errorMessage: String? {
        didSet {
            if let errorMessage {
                delegate?.errorDidOccur(message: errorMessage)
            }
        }
    }
    // MARK: - Delegate to handle view updates.
    weak var delegate: MovieViewModelDelegate?
    
    // MARK: - Services
    private let movieService = MovieService()
    
    // MARK: - Loads both movies and genres concurrently and updates the ViewModel.
    func loadMoviesAndGenres() async {
        performAsyncOperation {
            let (fetchedMovies, fetchedTopRated, fetchedGenres): ([Movie]?, [Movie]?, [Genre]?) = try await withThrowingTaskGroup(of: (movies: [Movie]?, topRated: [Movie]?, genres: [Genre]?).self) { group in
                
                var movies: [Movie]?
                var topRated: [Movie]?
                var genres: [Genre]?
                
                group.addTask {
                    (try await self.fetchPopularrMovies(), nil, nil)
                }
                
                group.addTask {
                    (nil, try await self.fetchTopRatedMovies(), nil)
                }
                
                group.addTask {
                    (nil, nil, try await self.fetchGenres())
                }
                for try await (partialMovies, partialTopRated, partialGenres) in group {
                    if let partialMovies = partialMovies { movies = partialMovies }
                    if let partialTopRated = partialTopRated { topRated = partialTopRated }
                    if let partialGenres = partialGenres { genres = partialGenres }
                }
                
                return (movies, topRated, genres)
            }
            
            if let fetchedMovies = fetchedMovies {
                self.movies = fetchedMovies
            }
            if let fetchedTopRated = fetchedTopRated {
                self.topRated = fetchedTopRated
            }
            if let fetchedGenres = fetchedGenres {
                self.genres = fetchedGenres
            }
        }
    }
    // MARK: - Searches for movies based on title and genre.
    func searchMovies(title: String, genre: Genre?) {
        guard !title.isEmpty || genre != nil else {
            resetSearch()
            return
        }
        
        performAsyncOperation { [weak self] in
            guard let self = self else { return}
            let movies = try await self.movieService.searchMovies(title: title,genreIds: genre != nil ? [genre!.id] : nil)
            await self.updateMovies(movies ?? [])
        }
    }
    // MARK: - Resets the search and reloads movies and genres.
    func resetSearch() {
        performAsyncOperation { [weak self] in
            
            self?.movies = []
            self?.genres = []
            self?.topRated = []
            await self?.loadMoviesAndGenres()
        }
    }
    // MARK: - Fetches popular movies from the service.
    private func fetchPopularrMovies() async throws -> [Movie] {
        return try await movieService.fetchPopularMovies()
    }
    //MARK: -Fetches top rated movies from the service.
    private func fetchTopRatedMovies() async throws -> [Movie] {
        return try await movieService.fetchTopRatedMovies()
    }
    // MARK: - Fetches available genres from the service.
    private func fetchGenres() async throws -> [Genre] {
        return try await movieService.fetchGenres()
    }
    // MARK: - Updates the list of movies in the ViewModel.
    private func updateMovies(_ movies: [Movie]) async {
        self.movies = movies
    }
    // MARK: - Handles errors by setting appropriate error message.
    private func handleError(_ error: Error) async {
        if let movieServiceError = error as? MovieServiceError {
            switch movieServiceError {
                case .invalidURL:
                    self.errorMessage = "Invalid URL"
                case .invalidResponse:
                    self.errorMessage = "Invalid Response"
                case .noData:
                    self.errorMessage = "No Data"
                case .decodingFailed:
                    self.errorMessage = "Decoding Failed"
                case .apiError(let message):
                    self.errorMessage = message
            }
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
    // MARK: - Performs the async operation while managing loading state and error handling.
    private func performAsyncOperation(operation: @escaping() async throws -> Void) {
        isLoading = true
        errorMessage = nil
        
        Task { [weak self] in
            do {
                try await operation()
            }catch{
                await self?.handleError(error)
            }
            self?.isLoading = false
        }
    }
}
