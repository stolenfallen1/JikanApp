//
//  WelcomeView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: AnimeView()) {
                    Text("Anime's")
                }
                NavigationLink(destination: MangaView()) {
                    Text("Manga's")
                }
            }
            .navigationTitle("Welcome View")
        }
    }
}

#Preview {
    WelcomeView()
}
