//
//  HighReviewAnime.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/24/25.
//

import Foundation

struct HighReviewAnimeResponse: Codable {
    let data: [HighReviewAnime]
}

struct HighReviewAnime: Codable, Identifiable {
    let mal_id: Int
    let entry: AnimeEntry
    let score: Int
    
    var id: Int { mal_id }
}

struct AnimeEntry: Codable {
    let mal_id: Int
    let title: String
    let images: Images
    
    struct Images: Codable {
        let jpg: ImageDetails
        
        struct ImageDetails: Codable {
            let image_url: String
        }
    }
}
