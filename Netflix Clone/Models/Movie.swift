//
//  Movie.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation

struct Movie: Identifiable,Codable,Equatable {
    // MARK: - Properties
    let id: Int
    let title:String
    let overview:String
    let releaseDate:String?
    let posterPath:String?
    let genreIds: [Int]?
    let vote: Double
    
    // MARK: - Computed Properties
    var posterURL: URL? {
        guard let posterPath = posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {
            return nil
        }
        return url
    }
    // MARK: - Coding Keys
    private enum CodingKeys: String,CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case vote = "vote_average"
    }
}
