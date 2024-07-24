//
//  AlphabetsView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.

import SwiftUI
import AVFoundation

struct AlphabetData: ContentData {
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

class AlphabetsViewModel: FlippableContent {
    typealias ContentType = AlphabetData
    typealias DisplayContentType = AlphabetContent
    
    enum CaseType {
        case upper, lower, both
    }
    
    struct AlphabetContent: Hashable {
        let upper: String
        let lower: String
    }
    
    @Published var currentAlphabetIndex: Int = 0
    @Published var selectedLanguage: String = "English"
    @Published var isRandomOrder: Bool = false
    @Published var isAudioEnabled: Bool = true
    @Published var play: Bool = false
    @Published var isFlipping: Bool = false
    @Published var selectedCaseType: CaseType = .upper
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var shuffledIndices: [Int] = []
    
    var currentContent: [AlphabetContent] {
        let content = AlphabetData.data[selectedLanguage] ?? AlphabetData.data["English"]!
        return content.map { AlphabetContent(upper: $0.uppercased(), lower: $0.lowercased()) }
    }
    
    func getCurrentIndex() -> Int {
        isRandomOrder ? shuffledIndices[currentAlphabetIndex] : currentAlphabetIndex
    }
    
    func previousContent() {
        guard !isFlipping else { return }
        isFlipping = true
        if isRandomOrder {
            currentAlphabetIndex = (currentAlphabetIndex - 1 + shuffledIndices.count) % shuffledIndices.count
        } else {
            currentAlphabetIndex = (currentAlphabetIndex - 1 + currentContent.count) % currentContent.count
        }
        playSound()
    }
    
    func nextContent() {
        guard !isFlipping else { return }
        isFlipping = true
        if isRandomOrder {
            currentAlphabetIndex = (currentAlphabetIndex + 1) % shuffledIndices.count
        } else {
            currentAlphabetIndex = (currentAlphabetIndex + 1) % currentContent.count
        }
        playSound()
    }
    
    func togglePlay() {
        play.toggle()
        if play {
            stopTimer()  // Stop any existing timer
            audioPlayer?.stop()  // Stop any existing audio
            startTimer()
            playSound()
        } else {
            stopTimer()
            audioPlayer?.stop()
        }
    }
    
    func playSound() {
        guard isAudioEnabled else { return }
        
        let letter = currentContent[getCurrentIndex()].lower
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
    
    func stopAllActivities() {
        play = false
        stopTimer()
        audioPlayer?.stop()
        audioPlayer = nil
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
        currentAlphabetIndex = 0
        resetShuffledIndices()
        playSound()
    }
    
    private func resetShuffledIndices() {
        shuffledIndices = Array(0..<currentContent.count).shuffled()
    }
}

struct AlphabetsView: View {
    @StateObject private var viewModel = AlphabetsViewModel()
    
    var body: some View {
        MainView(content: viewModel)
    }
}

struct CaseSelectionView: View {
    @Binding var selectedCaseType: AlphabetsViewModel.CaseType
    
    var body: some View {
        Picker("Case", selection: $selectedCaseType) {
            Text("Uppercase").tag(AlphabetsViewModel.CaseType.upper)
            Text("Lowercase").tag(AlphabetsViewModel.CaseType.lower)
            Text("Both").tag(AlphabetsViewModel.CaseType.both)
        }
        .pickerStyle(MenuPickerStyle())
    }
}

#Preview {
    AlphabetsView()
}
