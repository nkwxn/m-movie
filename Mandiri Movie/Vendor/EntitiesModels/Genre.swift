//
//  Genre.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

struct BaseGenres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
