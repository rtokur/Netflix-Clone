//
//  ConnectionError.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation

enum ConnectionError : Error {
    // MARK: - URL Handling Errors
    case invalidURL
        
    // MARK: - Response Handling Errors
    case invalidResponse
    case httpError(statusCode: Int)
        
    // MARK: - Decoding Errors
    case decodingFailed(error: Error)
        
    // MARK: - Data Handling Errors
    case noData
        
    // MARK: - Unknown Errors
    case unknown(Error)
}
