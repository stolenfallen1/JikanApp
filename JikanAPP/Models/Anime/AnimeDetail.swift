//
//  AnimeDetail.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 8/21/25.
//

import Foundation

struct AnimeDetailResponse: Codable {
    let data: AnimeDetail
}

struct AnimeDetail: Codable, Identifiable {
    let mal_id: Int
    let title: String
    let images: Anime.Images
    let synopsis: String?
    let background: String?
    let episodes: Int? 
    let duration: String?
    let status: String?
    let score: Double?
    let rank: Int?
    let popularity: Int?
    let season: String?
    let year: Int?
    
    // Studios
    let studios: [Studio]?
    
    struct Studio: Codable, Identifiable {
        let mal_id: Int
        let name: String
        var id: Int { mal_id }
    }
    
    var id: Int { mal_id }
}
