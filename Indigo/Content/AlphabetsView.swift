//
//  AlphabetsView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.
//

import SwiftUI
import AVFoundation

struct AlphabetData {
    static let data: [String: [String]] = [
        "English": [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
            "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        ],
        "French": [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
            "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        ],
        "Twi": [
            "A", "B", "D", "E", "Ɛ", "F", "G", "H", "I", "K", "L", "M", "N",
            "O", "Ɔ", "P", "R", "S", "T", "U", "W", "Y"
        ]
    ]
}

struct AlphabetsView: View {
    @State private var currentAlphabetIndex: Int = 0
    @State var selectedLanguage: String = "English"
    @State var isRandomOrder: Bool = false
    @State var isAudioEnabled: Bool = true
    @State var play: Bool = false
    @State private var timer: Timer? = nil
    @State private var isFlipping: Bool = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var shuffledIndices: [Int] = []

    private var currentAlphabet: [String] {
        AlphabetData.data[selectedLanguage] ?? AlphabetData.data["English"]!
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack {
                    Text("Alphabets")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    FlippingCard(
                        content: currentAlphabet[getCurrentIndex()],
                        isFlipping: $isFlipping
                    )
                }
                .frame(width: geometry.size.width * 3/4)
                
                Divider()
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 80)
                        
                        HStack(spacing: 30) {
                            Button(action: previousAlphabet) {
                                Image(systemName: "backward.fill")
                                    .foregroundColor(play || isFlipping ? .gray : .black)
                            }
                            .disabled(play || isFlipping)

                            Button(action: togglePlay) {
                                Image(systemName: play ? "pause.fill" : "play.fill")
                                    .foregroundColor(.black)
                            }
                            .frame(width: 60, height: 60)
                            .background(Color.blue.opacity(0.3))
                            .clipShape(Circle())

                            Button(action: nextAlphabet) {
                                Image(systemName: "forward.fill")
                                    .foregroundColor(play || isFlipping ? .gray : .black)
                            }
                            .disabled(play || isFlipping)
                        }
                        .font(.system(size: 24))
                    }
                    .frame(width: 250)
                    
                    VStack {
                        LanguageSelectionView(selectedLanguage: $selectedLanguage)
                        OrderSelectionView(isRandomOrder: $isRandomOrder)
                        AudioToggleView(isAudioEnabled: $isAudioEnabled)
                    }
                    .scaleEffect(0.5)
                }
                .frame(width: geometry.size.width * 1/4)
            }
        }
        .onAppear {
            resetView()
        }
        .onChange(of: selectedLanguage) { _, _ in
            resetView()
        }
        .onChange(of: isRandomOrder) { _, _ in
            resetView()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func togglePlay() {
        play.toggle()
        if play {
            startTimer()
            playAlphabetSound()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            nextAlphabet()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func previousAlphabet() {
        guard !isFlipping else { return }
        isFlipping = true
        withAnimation(.easeInOut(duration: 0.5)) {
            if isRandomOrder {
                currentAlphabetIndex = (currentAlphabetIndex - 1 + shuffledIndices.count) % shuffledIndices.count
            } else {
                currentAlphabetIndex = (currentAlphabetIndex - 1 + currentAlphabet.count) % currentAlphabet.count
            }
        }
        playAlphabetSound()
    }

    private func nextAlphabet() {
        guard !isFlipping else { return }
        isFlipping = true
        withAnimation(.easeInOut(duration: 0.5)) {
            if isRandomOrder {
                currentAlphabetIndex = (currentAlphabetIndex + 1) % shuffledIndices.count
            } else {
                currentAlphabetIndex = (currentAlphabetIndex + 1) % currentAlphabet.count
            }
        }
        playAlphabetSound()
    }

    private func playAlphabetSound() {
        guard isAudioEnabled else { return }
        
        let letter = currentAlphabet[getCurrentIndex()].lowercased()
        let language = selectedLanguage.lowercased()
        guard let url = Bundle.main.url(forResource: "\(language)_\(letter)", withExtension: "mp3") else {
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

    private func getCurrentIndex() -> Int {
        if isRandomOrder {
            return shuffledIndices[currentAlphabetIndex]
        } else {
            return currentAlphabetIndex
        }
    }

    private func resetShuffledIndices() {
        shuffledIndices = Array(0..<currentAlphabet.count).shuffled()
    }

    private func resetView() {
        currentAlphabetIndex = 0
        resetShuffledIndices()
        playAlphabetSound()
    }
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
    
    var body: some View {
        Picker("Language", selection: $selectedLanguage) {
            ForEach(Array(AlphabetData.data.keys), id: \.self) { language in
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
            Text("Order: Sequential").tag(false)
            Text("Order: Random").tag(true)
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

#Preview {
    AlphabetsView()
}
