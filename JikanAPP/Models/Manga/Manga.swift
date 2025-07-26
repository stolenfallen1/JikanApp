//
//  Manga.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/23/25.
//

import Foundation

struct MangaResponse: Codable {
    let data: [Manga]
}

struct Manga: Codable, Identifiable {
    let mal_id: Int
    let title: String
    let images: Images
    
    struct Images: Codable {
        let jpg: ImageDetails
        
        struct ImageDetails: Codable {
            let image_url: String
        }
    }
    
    var id: Int { mal_id }
}
