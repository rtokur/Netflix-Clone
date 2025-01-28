//
//  Genre.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation

struct Genre:Decodable, Identifiable,Equatable {
    // MARK: - Properties
    let id:Int
    let name:String
}
