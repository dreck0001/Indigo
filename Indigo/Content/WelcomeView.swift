//
//  WelcomeView.swift
//  Indigo
//
//  Created by Denis Ansah on 7/23/24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    @State private var currentPage = 0
    
    let pages = [
        WelcomePage(title: "Welcome to Indigo!", description: "Your fun learning companion", icon: "graduationcap.fill"),
        WelcomePage(title: "Alphabets", description: "Master letters in multiple languages", icon: "abc"),
        WelcomePage(title: "Numbers", description: "Count and spell numbers easily", icon: "textformat.123"),
        WelcomePage(title: "Colors & Shapes", description: "Explore a world of colors and shapes", icon: "paintpalette.fill")
    ]
    
    var body: some View {
        ZStack {
            Color.indigo.ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            Image(systemName: pages[index].icon)
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            
                            Text(pages[index].title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(pages[index].description)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .tag(index)
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                    if currentPage == pages.count - 1 {
                        withAnimation {
                            showWelcome = false
                        }
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }
                .button5()
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
            }
        }
    }
}

struct WelcomePage {
    let title: String
    let description: String
    let icon: String
}


#Preview {
    WelcomeView(showWelcome: .constant(true))
}
