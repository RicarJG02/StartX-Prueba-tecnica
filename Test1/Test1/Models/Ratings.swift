//
//  Ratings.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 30/3/23.
//

import Foundation

struct Ratings: Codable {
    var value: String
    var source: String?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case source = "Source"
    }
}
