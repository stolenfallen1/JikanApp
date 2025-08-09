//
//  SearchMangaViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/27/25.
//

import Foundation

@MainActor
class SearchMangaViewModel: ObservableObject, InfiniteLoadingViewModel {
    @Published var searchResults: [Manga] = []
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var currentPage: Int = 1
    
    private var currentQuery: String = ""
    private var searchTask: Task<Void, Never>?
    
    func searchManga(query: String) async {
        // Cancel previous search task
        searchTask?.cancel()
        
        if currentQuery != query {
            currentQuery = query
            currentPage = 1
            hasMorePages = true
            isLoadingMore = false
            searchResults = []
        }
        
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds delay to avoid too many API calls while typing
            
            guard !Task.isCancelled else { return }
            
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "https://api.jikan.moe/v4/manga?q=\(encoded)&page=\(currentPage)"
            guard let url = URL(string: urlString) else { return }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }
                
                let decoded = try JSONDecoder().decode(MangaResponse.self, from: data)
                
                if currentPage == 1 {
                    searchResults = decoded.data
                } else {
                    searchResults.append(contentsOf: decoded.data)
                }
            } catch {
                guard !Task.isCancelled else { return }
                print("Manga search error: \(error.localizedDescription)")
            }
        }
        
        await searchTask?.value
    }
    
    func loadMoreIfNeeded(query: String) async {
        guard !isLoadingMore && hasMorePages && currentQuery == query && !query.isEmpty else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        await searchManga(query: query)
        
        isLoadingMore = false
    }
}
