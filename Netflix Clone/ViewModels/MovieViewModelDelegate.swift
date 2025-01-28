//
//  MovieViewModelDelegate.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import Foundation
// MARK: - MovieViewModelDelegate Protocol
protocol MovieViewModelDelegate:AnyObject {
    // MARK: - Methods
    func moviesDidUpdate(movies: [Movie])
    func genresDidUpdate(genres: [Genre])
    func isLoadingDidChange(isLoading: Bool)
    func errorDidOccur(message: String)
}
