//
//  Video.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import Foundation

class BaseVideos: Codable {
    let id: Int?
    let results: [Video]?
}

class Video: Codable {
    let iso_639_1: String?
    let iso_3166_1: String?
    let name: String?
    let key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let published_at: String?
    let id: String?
    
    func getPublishedDate() -> Date {
        let formatter = DateFormatter()
        return formatter.date(from: published_at ?? "") ?? Date()
    }
}
