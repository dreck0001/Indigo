//
//  ColorsView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.
//

import SwiftUI
import AVFoundation

struct ColorData: ContentData {
    struct ColorContent: Hashable {
        let name: String
        let color: Color
    }
    
    static let data: [String: [ColorContent]] = [
        "English": [
            ColorContent(name: "Red", color: .red),
            ColorContent(name: "Blue", color: .blue),
            ColorContent(name: "Green", color: .green),
            ColorContent(name: "Yellow", color: .yellow),
            ColorContent(name: "Orange", color: .orange),
            ColorContent(name: "Purple", color: .purple),
            ColorContent(name: "Pink", color: .pink),
            ColorContent(name: "Brown", color: .brown),
            ColorContent(name: "Gray", color: .gray),
            ColorContent(name: "Black", color: .black),
            ColorContent(name: "White", color: .white)
        ],
        "French": [
            ColorContent(name: "Rouge", color: .red),
            ColorContent(name: "Bleu", color: .blue),
            ColorContent(name: "Vert", color: .green),
            ColorContent(name: "Jaune", color: .yellow),
            ColorContent(name: "Orange", color: .orange),
            ColorContent(name: "Violet", color: .purple),
            ColorContent(name: "Rose", color: .pink),
            ColorContent(name: "Marron", color: .brown),
            ColorContent(name: "Gris", color: .gray),
            ColorContent(name: "Noir", color: .black),
            ColorContent(name: "Blanc", color: .white)
        ],
        "Twi": [
            ColorContent(name: "Kɔkɔɔ", color: .red),
            ColorContent(name: "Bruu", color: .blue),
            ColorContent(name: "Ahabammono", color: .green),
            ColorContent(name: "Akokɔsradee", color: .yellow),
            ColorContent(name: "Akutu", color: .orange),
            ColorContent(name: "Beredum", color: .purple),
            ColorContent(name: "Mmɛrɛ", color: .pink),
            ColorContent(name: "Dodowee", color: .brown),
            ColorContent(name: "Nsonovee", color: .gray),
            ColorContent(name: "Tuntum", color: .black),
            ColorContent(name: "Fitaa", color: .white)
        ]
    ]
}

class ColorsViewModel: FlippableContent {
    typealias ContentType = ColorData
    typealias DisplayContentType = ColorData.ColorContent
    
    @Published var currentColorIndex: Int = 0
    @Published var selectedLanguage: String = "English"
    @Published var isRandomOrder: Bool = false
    @Published var isAudioEnabled: Bool = true
    @Published var play: Bool = false
    @Published var isFlipping: Bool = false
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var shuffledIndices: [Int] = []
    
    var currentContent: [ColorData.ColorContent] {
        ColorData.data[selectedLanguage] ?? ColorData.data["English"]!
    }
    
    func getCurrentIndex() -> Int {
        isRandomOrder ? shuffledIndices[currentColorIndex] : currentColorIndex
    }
    
    func previousContent() {
        guard !isFlipping else { return }
        isFlipping = true
        if isRandomOrder {
            currentColorIndex = (currentColorIndex - 1 + shuffledIndices.count) % shuffledIndices.count
        } else {
            currentColorIndex = (currentColorIndex - 1 + currentContent.count) % currentContent.count
        }
        playSound()
    }
    
    func nextContent() {
        guard !isFlipping else { return }
        isFlipping = true
        if isRandomOrder {
            currentColorIndex = (currentColorIndex + 1) % shuffledIndices.count
        } else {
            currentColorIndex = (currentColorIndex + 1) % currentContent.count
        }
        playSound()
    }
    
    func togglePlay() {
        play.toggle()
        if play {
            startTimer()
            playSound()
        } else {
            stopTimer()
        }
    }
    
    func playSound() {
        guard isAudioEnabled else { return }
        
        let colorName = currentContent[getCurrentIndex()].name.lowercased()
        let language = selectedLanguage.lowercased()
        guard let url = Bundle.main.url(forResource: "\(language)_\(colorName)", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            self?.nextContent()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetView() {
        currentColorIndex = 0
        resetShuffledIndices()
        playSound()
    }
    
    private func resetShuffledIndices() {
        shuffledIndices = Array(0..<currentContent.count).shuffled()
    }
    
    func stopAllActivities() {
        play = false
        stopTimer()
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

struct ColorsView: View {
    @StateObject private var viewModel = ColorsViewModel()
    
    var body: some View {
        MainView(content: viewModel)
    }
}

struct ColorFlippingCard: View {
    let content: ColorData.ColorContent
    @Binding var isFlipping: Bool

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(content.color)
                .frame(width: 1000, height: 750)
                .overlay(
                    Text(content.name)
                        .font(.system(size: 100))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
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

extension MainView where Content == ColorsViewModel {
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack {
                    Text("Colors")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    ColorFlippingCard(
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
                            .background(Color.primary1.opacity(0.3))
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


#Preview {
    ColorsView()
}
