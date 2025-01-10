//
//  Configuration.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/8/25.
//

import Foundation

struct Configuration: Codable {
    let changeKeys: [String]
    let images: Images
}

struct Images: Codable {
    let baseUrl: String
    let secureBaseUrl: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
    let stillSizes: [String]
}
