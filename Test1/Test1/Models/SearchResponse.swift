//
//  SearchResponse.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 30/3/23.
//

import Foundation

struct SearchResponse: Codable {
    let search: [Movie]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
