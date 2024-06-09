//
//  BaseView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.
//

import SwiftUI

struct BaseView: View {
    
    @State var subject: Subject  = .Alphabets
    @State var selectedLanguage: String = "English"
    @State var play: Bool = true
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                HStack {
                    Button(action: {}, label: { Text("Previous").button1() }).padding()
                    Button( action: { play.toggle() }, label: { Image(systemName: play ? "play.fill" : "stop.fill") } ).padding()
                    Button(action: {}, label: { Text("Next").button1() }).padding()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 150)

                Spacer()
                
                LanguageSelectionView(selectedLanguage: $selectedLanguage).scaleEffect(0.5)
            }

            
            Spacer()
            switch subject {
            case .Colors, .Shapes, .Photos, .Objects:
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 1500, height: 600)
            default:
                Text("Subject item")
            }
            Text("Item name")
            Spacer()
        }
    }
}

enum Subject {
    case Alphabets
    case Numbers
    case Colors
    case Shapes
    case Photos
    case Objects
    case Flags
    case Random
}
struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    
    var body: some View {
        Picker("Language", selection: $selectedLanguage) {
            Text("English").tag("en")
            Text("French").tag("fr")
        }
        .pickerStyle(MenuPickerStyle())
    }
}

#Preview { BaseView(subject: .Colors) }
#Preview { BaseView(subject: .Alphabets) }

