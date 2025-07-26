//
//  Genres.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/26/25.
//

import Foundation

struct GenreResponse: Codable {
    let data: [Genres]
}

struct Genres: Identifiable, Codable, Hashable {
    let mal_id: Int
    let name: String
    let count: Int
    
    var id: Int { mal_id }
}
