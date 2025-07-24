//
//  HighReviewManga.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/24/25.
//

import Foundation

struct HighReviewMangaResponse: Codable {
    let data: [HighReviewManga]
}

struct HighReviewManga: Codable, Identifiable {
    let mal_id: Int
    let entry: MangaEntry
    let score: Int
    
    var id: Int { mal_id }
}

struct MangaEntry: Codable {
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
