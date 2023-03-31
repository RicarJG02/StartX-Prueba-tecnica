//
//  Movie.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 30/3/23.
//

import Foundation

struct Movie: Codable, Equatable {
    let title: String
    let year: String
    let imdbID: String
    let posterURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case posterURL = "Poster"
    }
}
