//
//  NumbersView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.
//

import SwiftUI
import AVFoundation

struct NumberData: ContentData {
    struct NumberContent: Hashable {
        let number: String
        let spelling: String
    }
    
    static let data: [String: [NumberContent]] = [
        "English": [
            NumberContent(number: "0", spelling: "zero"),
            NumberContent(number: "1", spelling: "one"),
            NumberContent(number: "2", spelling: "two"),
            NumberContent(number: "3", spelling: "three"),
            NumberContent(number: "4", spelling: "four"),
            NumberContent(number: "5", spelling: "five"),
            NumberContent(number: "6", spelling: "six"),
            NumberContent(number: "7", spelling: "seven"),
            NumberContent(number: "8", spelling: "eight"),
            NumberContent(number: "9", spelling: "nine"),
            NumberContent(number: "10", spelling: "ten"),
            NumberContent(number: "11", spelling: "eleven"),
            NumberContent(number: "12", spelling: "twelve"),
            NumberContent(number: "13", spelling: "thirteen"),
            NumberContent(number: "14", spelling: "fourteen"),
            NumberContent(number: "15", spelling: "fifteen"),
            NumberContent(number: "16", spelling: "sixteen"),
            NumberContent(number: "17", spelling: "seventeen"),
            NumberContent(number: "18", spelling: "eighteen"),
            NumberContent(number: "19", spelling: "nineteen"),
            NumberContent(number: "20", spelling: "twenty")
        ],
        "French": [
            NumberContent(number: "0", spelling: "zéro"), NumberContent(number: "1", spelling: "un"),
            NumberContent(number: "2", spelling: "deux"), NumberContent(number: "3", spelling: "trois"),
            NumberContent(number: "4", spelling: "quatre"), NumberContent(number: "5", spelling: "cinq"),
            NumberContent(number: "6", spelling: "six"), NumberContent(number: "7", spelling: "sept"),
            NumberContent(number: "8", spelling: "huit"), NumberContent(number: "9", spelling: "neuf"),
            NumberContent(number: "10", spelling: "dix"), NumberContent(number: "11", spelling: "onze"),
            NumberContent(number: "12", spelling: "douze"), NumberContent(number: "13", spelling: "treize"),
            NumberContent(number: "14", spelling: "quatorze"), NumberContent(number: "15", spelling: "quinze"),
            NumberContent(number: "16", spelling: "seize"), NumberContent(number: "17", spelling: "dix-sept"),
            NumberContent(number: "18", spelling: "dix-huit"), NumberContent(number: "19", spelling: "dix-neuf"),
            NumberContent(number: "20", spelling: "vingt")
        ],
        "Twi": [
            NumberContent(number: "0", spelling: "hwee"), NumberContent(number: "1", spelling: "baako"),
            NumberContent(number: "2", spelling: "mmienu"), NumberContent(number: "3", spelling: "mmiɛnsa"),
            NumberContent(number: "4", spelling: "nnan"), NumberContent(number: "5", spelling: "nnum"),
            NumberContent(number: "6", spelling: "nsia"), NumberContent(number: "7", spelling: "nson"),
            NumberContent(number: "8", spelling: "nwɔtwe"), NumberContent(number: "9", spelling: "nkron"),
            NumberContent(number: "10", spelling: "du"), NumberContent(number: "11", spelling: "dubaako"),
            NumberContent(number: "12", spelling: "dummienu"), NumberContent(number: "13", spelling: "dummiɛnsa"),
            NumberContent(number: "14", spelling: "dunan"), NumberContent(number: "15", spelling: "dunum"),
            NumberContent(number: "16", spelling: "dunsia"), NumberContent(number: "17", spelling: "dunson"),
            NumberContent(number: "18", spelling: "dunwɔtwe"), NumberContent(number: "19", spelling: "dunkron"),
            NumberContent(number: "20", spelling: "aduonu")
        ]
    ]
}

class NumbersViewModel: FlippableContent {
    typealias ContentType = NumberData
    typealias DisplayContentType = NumberData.NumberContent
    
    enum NumberRange {
        case zeroToTen, zeroToTwenty, zeroToFifty, zeroToHundred
    }
        
    @Published var currentNumberIndex: Int = 0
    @Published var selectedLanguage: String = "English"
    @Published var isRandomOrder: Bool = false
    @Published var isAudioEnabled: Bool = true
    @Published var play: Bool = false
    @Published var isFlipping: Bool = false
    @Published var selectedRange: NumberRange = .zeroToTwenty
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var shuffledIndices: [Int] = []
    
    var currentContent: [NumberData.NumberContent] {
        let allContent = NumberData.data[selectedLanguage] ?? NumberData.data["English"]!
        switch selectedRange {
        case .zeroToTen:
            return Array(allContent[0...10])
        case .zeroToTwenty:
            return allContent
        case .zeroToFifty:
            return allContent + (21...50).map { NumberData.NumberContent(number: "\($0)", spelling: "") }
        case .zeroToHundred:
            return allContent + (21...100).map { NumberData.NumberContent(number: "\($0)", spelling: "") }
        }
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
            startTimer()
            playSound()
        } else {
            stopTimer()
        }
    }
    
    func playSound() {
        guard isAudioEnabled else { return }
        
        let number = currentContent[getCurrentIndex()].number
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

struct NumbersView: View {
    @StateObject private var viewModel = NumbersViewModel()
    
    var body: some View {
        MainView(content: viewModel)
    }
}

struct RangeSelectionView: View {
    @Binding var selectedRange: NumbersViewModel.NumberRange
    
    var body: some View {
        Picker("Range", selection: $selectedRange) {
            Text("0-10").tag(NumbersViewModel.NumberRange.zeroToTen)
            Text("0-20").tag(NumbersViewModel.NumberRange.zeroToTwenty)
            Text("0-50").tag(NumbersViewModel.NumberRange.zeroToFifty)
            Text("0-100").tag(NumbersViewModel.NumberRange.zeroToHundred)
        }
        .pickerStyle(MenuPickerStyle())
    }
}

#Preview {
    NumbersView()
}
