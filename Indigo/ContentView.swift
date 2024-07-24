//
//  ContentView.swift
//  Indigo
//
//  Created by Denis on 6/7/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @State private var showWelcome = false
    
    var body: some View {
        ZStack {
            TabView {
                AlphabetsView().tabItem { Label("Alphabets", systemImage: "abc") }
                NumbersView().tabItem { Label("Numbers", systemImage: "textformat.123") }
                ColorsView().tabItem { Label("Colors", systemImage: "paintbrush.pointed") }
                ShapesView().tabItem { Label("Shapes", systemImage: "dot.squareshape.fill") }
                PhotosView().tabItem { Label("Album", systemImage: "person.2.crop.square.stack") }
                ObjectsView().tabItem { Label("Objects", systemImage: "apple.logo") }
                FlagsView().tabItem { Label("Flags", systemImage: "flag.filled.and.flag.crossed") }
                RandomView().tabItem { Label("Random", systemImage: "wand.and.stars.inverse") }
            }
            .accentColor(.indigo)
        }
        .fullScreenCover(isPresented: $showWelcome) {
            WelcomeView(showWelcome: $showWelcome)
        }
        .onAppear {
            if !hasSeenWelcome {
                showWelcome = true
                hasSeenWelcome = true
            }
        }
    }
}

#Preview {
    ContentView()
}
