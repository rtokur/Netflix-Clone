//
//  MovieService.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation

class MovieService {
    
    // MARK: - Properties
    private let connectionHelper = ConnectionHelper()
    // MARK: - Fetch Data Method
    private func fetchData<T: Decodable>(path: String, queryItems:[URLQueryItem], methodName: String) async throws -> T {
        print("Fetching \(methodName) data with path: \(path) and query \(queryItems)")
        
        do {
            // Creating URL and being sure to right
            let url = try connectionHelper.createurl(path: path, queryItems: queryItems)
            print("Created URL: \(url)") // Verify URL
            
            // Fetching the data
            let response: T = try await connectionHelper.fetchData(from: url)
            print("Fetched data: \(response)") // Control the data
            
            return response
        } catch let error as ConnectionError {
            // Error details are processed in detail
            switch error {
            case .invalidURL:
                throw MovieServiceError.invalidURL
            case .httpError(let statusCode):
                throw MovieServiceError.apiError(message: "HTTP error \(statusCode)")
            case .decodingFailed:
                throw MovieServiceError.decodingFailed
            case .invalidResponse:
                throw MovieServiceError.invalidResponse
            case .noData:
                throw MovieServiceError.noData
            case .unknown(let error):
                throw MovieServiceError.apiError(message: "Unknown error: \(error.localizedDescription)")
            }
        } catch {
            // Other errors
            throw MovieServiceError.apiError(message: error.localizedDescription)
        }
    }

    // MARK: - Fetching Popular Movies From API
    func fetchPopularMovies() async throws->[Movie]{
        let response: MovieResponse = try await fetchData(path: "/movie/popular", queryItems: [URLQueryItem(name: "page", value: "1")], methodName: "popular movied")
        return response.results
    }
    
    //MARK: -Fetching Top Rated Movies From API
    func fetchTopRatedMovies() async throws->[Movie]{
        let response:MovieResponse = try await fetchData(path: "/movie/top_rated", queryItems: [URLQueryItem(name: "page", value: "1")], methodName: "top rated movies")
        return response.results
    }
    //MARK: -Fetching Videos
    func fetchMovieVideos(movieId:Int) async throws->[Video] {
        let response: VideoResponse = try await fetchData(path: "/movie/\(movieId)/videos", queryItems: [], methodName: "movie videos")
        return response.results
    }
    
    //MARK: -Search Movies
    func searchMovies(title: String? = nil, genreIds: [Int]? = nil) async throws->[Movie] {
        var queryItems:[URLQueryItem] = []
        
        if let title = title, !title.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: title))
        }
        
        if let genreIds = genreIds, !genreIds.isEmpty {
            let genreIdsString = genreIds.map{String($0)}.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "with_genres", value: genreIdsString))
        }
        
        let endpoint = title != nil && !title!.isEmpty ? "/search/movie" : "/discover/movie"
        let response: MovieResponse = try await fetchData(path: endpoint, queryItems: queryItems, methodName: "movies")
        
        return response.results
        
    }
    //MARK: - Fetch genres from the API
    func fetchGenres() async throws->[Genre] {
        let response: GenreResponse = try await fetchData(path: "/genre/movie/list", queryItems: [], methodName: "genres")
        return response.genres
    }
}
