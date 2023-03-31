//
//  DetailResponse.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 30/3/23.
//

import Foundation

struct DetailResponse: Codable {
    let imdbID: String
    let title: String
    let ratings: [Ratings]
    let director: String
    let plot: String
    
    enum CodingKeys: String, CodingKey {
        case imdbID = "imdbID"
        case title = "Title"
        case ratings = "Ratings"
        case director = "Director"
        case plot = "Plot"
    }
}
