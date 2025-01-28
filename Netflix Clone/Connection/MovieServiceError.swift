//
//  MovieServiceError.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation

enum MovieServiceError:Error {
    // MARK: - URL Handling Errors
    case invalidURL
    // MARK: - Response Handling Errors
    case invalidResponse
    // MARK: - Data Handling Errors
    case noData
    // MARK: - Decoding Errors
    case decodingFailed
    // MARK: - API Errors
    case apiError(message: String)
}
