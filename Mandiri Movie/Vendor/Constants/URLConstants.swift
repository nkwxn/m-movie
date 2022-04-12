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
    public static let getDiscoverMovies = "\(baseURL)/discover/movie?api_key=\(apiKey)"
    
    func discoverMovies(by genreId: Int) -> String {
        return "\(URLConstants.getDiscoverMovies)&with_genres=\(genreId)"
    }
}
