//
//  ContentView.swift
//  Indigo
//
//  Created by Denis on 6/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AlphabetsView().tabItem { Label("Alphabets", systemImage: "abc") }.tag(0)
            NumbersView().tabItem { Label("Numbers", systemImage: "textformat.123") }.tag(1)
            ColorsView().tabItem { Label("Colors", systemImage: "paintbrush.pointed") }.tag(2)
            ShapesView().tabItem { Label("Shapes", systemImage: "dot.squareshape.fill") }.tag(3)
            PhotosView().tabItem { Label("Album", systemImage: "person.2.crop.square.stack") }.tag(4)
            ObjectsView().tabItem { Label("Objects", systemImage: "apple.logo") }.tag(5)
            FlagsView().tabItem { Label("FLagss", systemImage: "flag.filled.and.flag.crossed") }.tag(6)
            RandomView().tabItem { Label("Random", systemImage: "wand.and.stars.inverse") }.tag(7)
        }
    }
}

#Preview {
    ContentView()
}
