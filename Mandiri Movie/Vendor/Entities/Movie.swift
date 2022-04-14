//
//  Movie.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

struct BaseMovies: Codable {
    let page: Int?
    let results: [Movie]?
    let total_pages: Int?
    let total_results: Int?
    let errors: [String]?
}

struct Movie: Codable {
    let id: Int?
    let adult: Bool?
    let genre_ids: [Int]?
    let genres: [Genre]?
    let homepage: String?
    let backdrop_path: String?
    let original_language: String?
    let original_title: String?
    let title: String?
    let tagline: String?
    let revenue: Int? // Revenue in USD
    let runtime: Int? // runtime in minute
    let production_companies: [ProductionCompany]?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    private let release_date: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    
    func getReleaseDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-mm-dd"
        let df2 = DateFormatter()
        df2.dateStyle = .medium
        df2.timeStyle = .none
        let date =  df.date(from: release_date ?? "") ?? Date()
        return df2.string(from: date)
    }
    
    func getFormattedRevenue() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
        return numberFormatter.string(from: NSNumber(integerLiteral: revenue ?? 0)) ?? ""
    }
    
    func formatRuntime() -> String {
        guard let runtime = runtime else {
            return "0"
        }

        let hour = runtime / 60
        let min = runtime - (hour * 60)
        return "\(hour)h \(min)min"
    }
}

struct ProductionCompany: Codable {
    let id: Int?
    let logo_path: String?
    let name: String?
}
