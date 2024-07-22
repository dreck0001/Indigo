//
//  CommonViews.swift
//  Indigo
//
//  Created by Denis Ansah on 7/21/24.
//


import SwiftUI
import AVFoundation

protocol ContentData {
    static var data: [String: [String]] { get }
}

protocol FlippableContent: ObservableObject {
    associatedtype ContentType: ContentData
    
    var currentContent: [String] { get }
    var selectedLanguage: String { get set }
    var isRandomOrder: Bool { get set }
    var isAudioEnabled: Bool { get set }
    var play: Bool { get set }
    var isFlipping: Bool { get set }
    
    func getCurrentIndex() -> Int
    func previousContent()
    func nextContent()
    func togglePlay()
    func playSound()
    func resetView()
    func stopAllActivities()

}

struct FlippingCard: View {
    let content: String
    @Binding var isFlipping: Bool

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue.opacity(0.3))
                .frame(width: 1000, height: 750)
                .overlay(
                    Text(content)
                        .font(.system(size: 900))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .rotation3DEffect(
                            .degrees(rotation),
                            axis: (x: 0, y: 1, z: 0)
                        )
                )
                .rotation3DEffect(
                    .degrees(rotation),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onChange(of: isFlipping) { _, startFlipping in
            if startFlipping {
                withAnimation(.easeInOut(duration: 0.5)) {
                    rotation -= 180
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFlipping = false
                    rotation = 0  // Reset rotation after flip
                }
            }
        }
    }
}

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    let languages: [String]
    
    var body: some View {
        Picker("Language", selection: $selectedLanguage) {
            ForEach(languages, id: \.self) { language in
                Text("Language: \(language)").tag(language)
            }
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct OrderSelectionView: View {
    @Binding var isRandomOrder: Bool
    
    var body: some View {
        Picker("Order", selection: $isRandomOrder) {
            Text("Sequential").tag(false)
            Text("Random").tag(true)
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct AudioToggleView: View {
    @Binding var isAudioEnabled: Bool
    
    var body: some View {
        Picker("Audio", selection: $isAudioEnabled) {
            Text("Audio: Off").tag(false)
            Text("Audio: On").tag(true)
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct MainView<Content: FlippableContent>: View {
    @ObservedObject var content: Content
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack {
                    Text(String(describing: type(of: content)).replacingOccurrences(of: "ViewModel", with: ""))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    FlippingCard(
                        content: content.currentContent[content.getCurrentIndex()],
                        isFlipping: $content.isFlipping
                    )
                }
                .frame(width: geometry.size.width * 3/4)
                
                Divider()
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 60)
                        
                        HStack(spacing: 30) {
                            Button(action: content.previousContent) {
                                Image(systemName: "backward.fill")
                                    .foregroundColor(content.play || content.isFlipping ? .gray : .black)
                            }
                            .disabled(content.play || content.isFlipping)

                            Button(action: content.togglePlay) {
                                Image(systemName: content.play ? "pause.fill" : "play.fill")
                                    .foregroundColor(.black)
                            }
                            .frame(width: 60, height: 60)
                            .background(Color.blue.opacity(0.3))
                            .clipShape(Circle())

                            Button(action: content.nextContent) {
                                Image(systemName: "forward.fill")
                                    .foregroundColor(content.play || content.isFlipping ? .gray : .black)
                            }
                            .disabled(content.play || content.isFlipping)
                        }
                        .font(.system(size: 24))
                    }
                    .frame(width: 250)
                    
                    VStack {
                        LanguageSelectionView(selectedLanguage: $content.selectedLanguage, languages: Array(Content.ContentType.data.keys))
                        OrderSelectionView(isRandomOrder: $content.isRandomOrder)
                        AudioToggleView(isAudioEnabled: $content.isAudioEnabled)
                    }
                    .scaleEffect(0.5)
                }
                .frame(width: geometry.size.width * 1/4)
            }
        }
        .onAppear {
            content.resetView()
        }
        .onDisappear {
            content.stopAllActivities()
        }
        .onChange(of: content.selectedLanguage) { _, _ in
            content.resetView()
        }
        .onChange(of: content.isRandomOrder) { _, _ in
            content.resetView()
        }
    }
}
