//
//  MovieResponse.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation
struct MovieResponse : Codable {
    // MARK: - Properties
    let page:Int
    let results : [Movie]
    let totalPages : Int
    let totalResults : Int
    // MARK: - Coding Keys
    private enum CodingKeys:String,CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
