//
//  Movie.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let backdropPath: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
