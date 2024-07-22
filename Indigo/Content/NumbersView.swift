//
//  NumbersView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.
//

import SwiftUI
import AVFoundation

struct NumberData: ContentData {
    static let data: [String: [String]] = [
        "English": Array(0...20).map { String($0) },
        "French": ["zéro", "un", "deux", "trois", "quatre", "cinq", "six", "sept", "huit", "neuf", "dix",
                   "onze", "douze", "treize", "quatorze", "quinze", "seize", "dix-sept", "dix-huit", "dix-neuf", "vingt"],
        "Twi": ["hwee", "baako", "mmienu", "mmiɛnsa", "nnan", "nnum", "nsia", "nson", "nwɔtwe", "nkron", "du",
                "dubaako", "dummienu", "dummiɛnsa", "dunan", "dunum", "dunsia", "dunson", "dunwɔtwe", "dunkron", "aduonu"]
    ]
}

class NumbersViewModel: FlippableContent {
    typealias ContentType = NumberData
    
    @Published var currentNumberIndex: Int = 0
    @Published var selectedLanguage: String = "English"
    @Published var isRandomOrder: Bool = false
    @Published var isAudioEnabled: Bool = true
    @Published var play: Bool = false
    @Published var isFlipping: Bool = false
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var shuffledIndices: [Int] = []
    
    var currentContent: [String] {
        NumberData.data[selectedLanguage] ?? NumberData.data["English"]!
    }
    
    func getCurrentIndex() -> Int {
        isRandomOrder ? shuffledIndices[currentNumberIndex] : currentNumberIndex
    }
    
    func previousContent() {
        guard !isFlipping else { return }
        isFlipping = true
        if isRandomOrder {
            currentNumberIndex = (currentNumberIndex - 1 + shuffledIndices.count) % shuffledIndices.count
        } else {
            currentNumberIndex = (currentNumberIndex - 1 + currentContent.count) % currentContent.count
        }
        playSound()
    }
    
    func nextContent() {
        guard !isFlipping else { return }
        isFlipping = true
        if isRandomOrder {
            currentNumberIndex = (currentNumberIndex + 1) % shuffledIndices.count
        } else {
            currentNumberIndex = (currentNumberIndex + 1) % currentContent.count
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
        
        let number = currentContent[getCurrentIndex()].lowercased()
        let language = selectedLanguage.lowercased()
        guard let url = Bundle.main.url(forResource: "\(language)_\(number)", withExtension: "mp3") else {
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
        currentNumberIndex = 0
        resetShuffledIndices()
        playSound()
    }
    
    func stopAllActivities() {
        play = false
        stopTimer()
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    private func resetShuffledIndices() {
        shuffledIndices = Array(0..<currentContent.count).shuffled()
    }
}

struct NumbersView: View {
    @StateObject private var viewModel = NumbersViewModel()
    
    var body: some View {
        MainView(content: viewModel)
    }
}


#Preview {
    NumbersView()
}
