//
//  VideoResponse.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation
struct VideoResponse : Codable {
    // MARK: - Properties
    let id: Int
    let results : [Video]
}
