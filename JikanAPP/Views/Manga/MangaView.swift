//
//  MangaView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

struct MangaView: View {
    @StateObject private var topMangaViewModel = TopMangaViewModel()
    @StateObject private var genreListViewModel = GenreListViewModel()
    @StateObject private var genreMangaViewModel = GenreMangaViewModel()
    @StateObject private var searchMangaViewModel = SearchMangaViewModel()
    @State private var searchText = ""
    @State private var selectedGenreID: Int? = nil
    @State private var selectedGenreName: String = "Top Manga"
    @State private var showGenreSheet = false
    @State private var searchFilterText = ""
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var filteredGenres: [Genres] {
        let list = searchFilterText.isEmpty ? genreListViewModel.genres : genreListViewModel.genres.filter {
            $0.name.localizedCaseInsensitiveContains(searchFilterText)
        }
        
        // Remove weird ass duplicates by name
        var seen = Set<String>()
        return list.filter { genre in
            guard !seen.contains(genre.name.lowercased()) else { return false }
            seen.insert(genre.name.lowercased())
            return true
        }
    }
    
    var mangaToDisplay: [Manga] {
        if !searchText.isEmpty {
            return searchMangaViewModel.searchResults
        } else if let _ = selectedGenreID {
            return genreMangaViewModel.mangaList
        } else {
            return topMangaViewModel.topMangaList
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(mangaToDisplay) { manga in
                    MangaItemView(manga: manga)
                }
                .padding()
            }
        }
        .navigationTitle(selectedGenreName)
        .navigationBarTitleDisplayMode(.large)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showGenreSheet = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .imageScale(.large)
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .task {
            await topMangaViewModel.fetchTopManga()
        }
        
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .onChange(of: searchText, initial: false, { _, newValue in
            Task {
                await searchMangaViewModel.searchManga(query: newValue)
            }
        })
        
        .sheet(isPresented: $showGenreSheet) {
            VStack(spacing: 0) {
                // Sheet Header
                HStack {
                    Text("Select Genre")
                        .font(.headline)
                    Spacer()
                    Button("Cancel") {
                        showGenreSheet = false
                        searchFilterText = ""
                    }
                    .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Search bar
                TextField("Search Genres...", text: $searchFilterText)
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding()

                // Genre List
                List(filteredGenres) { genre in
                    Button {
                        selectedGenreName = genre.name
                        selectedGenreID = genre.mal_id
                        showGenreSheet = false
                        searchFilterText = ""
                    } label: {
                        HStack {
                            Text(genre.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("(\(genre.count))")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchFilterText, placement: .automatic)
                .task {
                    if genreListViewModel.genres.isEmpty {
                        await genreListViewModel.fetchGenres(for: "manga")
                    }
                }
            }
            .presentationDetents([.fraction(0.7)]) // Present sheet 70%
        }
        .onChange(of: selectedGenreID, initial: false) { _, newValue in
            if let id = newValue {
                Task {
                    await genreMangaViewModel.fetchManga(for: id)
                }
            }
        }
    }
}


struct MangaItemView: View {
    let manga: Manga
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: manga.images.jpg.image_url)) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 20)
                            .clipped()
                    case .failure:
                        Image(systemName: "xmark.octagon")
                    @unknown default:
                        EmptyView()
                }
            }
            Text(manga.title)
                .font(.caption)
                .lineLimit(2)
                .padding([.leading, .trailing], 4)
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
//    MangaView()
}
