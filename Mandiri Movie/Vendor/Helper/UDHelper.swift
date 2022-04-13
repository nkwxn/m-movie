//
//  UDHelper.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import Foundation

class UDHelper {
    let defaults = UserDefaults.standard
    static let shared = UDHelper()
    
    func inputGenres(value: [Int: String]) {
        defaults.setValue(value, forKey: "genres")
    }
    
    func getGenres(key: Int) -> String {
        let genres = defaults.dictionary(forKey: "genres") as? [Int: String] ?? [:]
        return genres[key] ?? ""
    }
}
