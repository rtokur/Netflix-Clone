//
//  ConnectionHelper.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation

class ConnectionHelper {
    // MARK: - Properties
    private let apiKey = "11904d3e3a1ac234eeddcd3bc0d3ff40"
    private let baseUrl = "https://api.themoviedb.org/3"
    private let language = "en-US"
    
    private let session: URLSession
    
    // MARK: - Initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - URL Creation
    func createurl(path: String, queryItems: [URLQueryItem]) throws -> URL {
        guard var components = URLComponents(string: baseUrl + path) else {
            throw ConnectionError.invalidURL
        }
        
        components.queryItems = queryItems + [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language)
        ]
        
        guard let url = components.url else {
            throw ConnectionError.invalidURL
        }
        
        return url
    }
    
    // MARK: - Data Fetching
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data,repsonse) = try await session.data(from:url)
        
        guard let httpResponse = repsonse as? HTTPURLResponse else {
            throw ConnectionError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ConnectionError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }catch {
            throw ConnectionError.decodingFailed(error: error)
        }
    }
}
