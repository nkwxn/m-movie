//
//  Review.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import Foundation

struct BaseReviews: Codable {
    let id: Int?
    let page: Int?
    let results: [Review]?
    let total_pages: Int?
    let total_results: Int?
    let errors: [String]?
}

struct Review: Codable {
    let author: String?
    let author_details: Author?
    let content: String?
    private let created_at: String?
    private let updated_at: String?
    
    func getCreatedDate() -> Date {
        let formatter = DateFormatter()
        return formatter.date(from: created_at ?? "") ?? Date()
    }
    
    func getUpdatedDate() -> Date {
        let formatter = DateFormatter()
        return formatter.date(from: updated_at ?? "") ?? Date()
    }
    
    func getFormattedDateCategory() -> String {
        let createdDate = getCreatedDate()
        let updatedDate = getUpdatedDate()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let formattedCreate = formatter.string(from: createdDate)
        let formattedUpdate = formatter.string(from: updatedDate)
        
        if formattedCreate == formattedUpdate {
            return formattedCreate
        } else {
            return "\(formattedCreate) (updated on \(formattedUpdate))"
        }
    }
}

struct Author: Codable {
    let name: String?
    let username: String?
    let avatar_path: String?
    let rating: Int?
}
