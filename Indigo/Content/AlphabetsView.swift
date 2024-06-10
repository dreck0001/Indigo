//
//  AlphabetsView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.
//

import SwiftUI

struct AlphabetsView: View {
    @State private var currentAlphabetIndex: Int = 0
    @State var selectedLanguage: String = "English"
    @State var play: Bool = false
    @State private var timer: Timer? = nil

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: previousAlphabet, label: {
                        Text("Previous")
                            .button1()
                            .buttonDisable(status: play)
                    })
                    .disabled(play)

                    Button(action: { togglePlay() }, label: {
                        Image(systemName: play ? "stop.fill" : "play.fill")
//                            .button1()
                    })
                    
                    Button(action: nextAlphabet, label: {
                        Text("Next")
                            .button1()
                            .buttonDisable(status: play)
                    })
                    .disabled(play)
                }
                .buttonStyle(PlainButtonStyle())

                HStack {
                    Spacer()
                    LanguageSelectionView(selectedLanguage: $selectedLanguage)
                        .scaleEffect(0.5)
                }
            }.padding(.top, -50)
            
            Text("Alphabets")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Card displaying the current alphabet
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue.opacity(0.3))
                .frame(width: 550, height: 650)
                .overlay(
                    Text(AlphabetData.allCases[currentAlphabetIndex].rawValue)
                        .font(.system(size: 500))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                )
            
            Spacer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func togglePlay() {
        play.toggle()
        if play {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            currentAlphabetIndex = (currentAlphabetIndex + 1) % AlphabetData.allCases.count
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func previousAlphabet() {
        currentAlphabetIndex = (currentAlphabetIndex - 1 + AlphabetData.allCases.count) % AlphabetData.allCases.count
    }

    private func nextAlphabet() {
        currentAlphabetIndex = (currentAlphabetIndex + 1) % AlphabetData.allCases.count
    }
}

enum AlphabetData: String, CaseIterable {
    case A = "A"
    case B = "B"
    case C = "C"
    // Continue for the rest of the alphabets...
}

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    
    var body: some View {
        Picker("Language", selection: $selectedLanguage) {
            Text("English").tag("English")
            Text("French").tag("French")
        }
        .pickerStyle(MenuPickerStyle())
    }
}




#Preview {
    AlphabetsView()
}
