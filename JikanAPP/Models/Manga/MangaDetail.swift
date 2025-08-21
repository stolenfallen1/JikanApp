//
//  MangaDetail.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 8/21/25.
//

import Foundation

struct MangaDetailResponse: Codable {
    let data: MangaDetail
}

struct MangaDetail: Codable, Identifiable {
    let mal_id: Int
    let title: String
    let images: Manga.Images
    let synopsis: String?
    let background: String?
    let chapters: Int?
    let volumes: Int?
    let status: String?
    let score: Double?
    let rank: Int?
    let popularity: Int?
    let year: Int?
    
    let authors: [Author]?
    
    struct Author: Codable, Identifiable {
        let mal_id: Int
        let name: String
        var id: Int { mal_id }
    }
    
    var id: Int { mal_id }
}
