//
//  Movie.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

struct BaseMovies: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct Movie: Codable {
    let id: Int
    let adult: Bool
    let backdrop_path: String
    let original_language: String
    let original_title: String
    let title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    private let release_date: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    func getReleaseDate() -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-mm-dd"
        return df.date(from: release_date) ?? Date.now
    }
}
