//
//  URLConstants.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

// API Key: a48deeb08653a50b070ed0dd82b8a87b

struct URLConstants {
    private static let baseURL = "https://api.themoviedb.org/3"
    private static let apiKey = "a48deeb08653a50b070ed0dd82b8a87b"
    
    public static let getGenres = "\(baseURL)/genre/movie/list?api_key=\(apiKey)"
    private static let getDiscoverMovies = "\(baseURL)/discover/movie?api_key=\(apiKey)"
//    private static let imageURL = "https://image.tmdb.org/t/p/w500"
    
    public static func getDiscoverMovies(by genreId: Int?, on page: Int? = nil) -> String {
        if let genreId = genreId {
            return "\(URLConstants.getDiscoverMovies)&with_genres=\(genreId)\(page != nil ? "&page=\(page!)" : "")"
        } else {
            return URLConstants.getDiscoverMovies
        }
    }
    
    public static func getImageURL(by path: String) -> String {
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
}
