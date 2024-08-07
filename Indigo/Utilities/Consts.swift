//
//  Consts.swift
//  Adwumax1
//
//  Created by Denis on 2/17/24.
//

import SwiftUI
import Foundation


enum Menu: String {
    case Explore = "list.bullet.below.rectangle"
    case Services
    case Messages
    case Profile

}

extension Color {
    private static func rgb(red: Double, green: Double, blue: Double) -> Color {
        return Color(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    static let indigo = Color.rgb(red: 75, green: 0, blue: 130) // Indigo color
    static let indigoLight = Color.rgb(red: 111, green: 54, blue: 170) // Lighter indigo for contrast
    static let indigoDark = Color.rgb(red: 54, green: 0, blue: 94) // Darker indigo for contrast
    
//    static let primaryBlueGreen = Color(red: 50 / 255, green: 186 / 255, blue: 174 / 255) //#32baae
    static let primaryRed = Color(.red)
    static let primaryBlueGreen2 = UIColor(Color(#colorLiteral(red: 0.1960784314, green: 0.7294117647, blue: 0.6823529412, alpha: 0.04)))
    static let primaryBlueGreen3 = Color(#colorLiteral(red: 0.1960784314, green: 0.7294117647, blue: 0.6823529412, alpha: 0.04))
    
    static let primary1 = indigo
    static let secondary1 = Color.rgb(red: 175, green: 50, blue: 186)
    static let tertiary1 = Color.rgb(red: 186, green: 175, blue: 50)


}

struct Consts {
    struct Title {
        static let fontName = "Baskerville-Bold"        
        static let fontSize: CGFloat = 40
        static let fontSize2: CGFloat = 30
    }
    struct Icon {
        static let fontName = "Arial Rounded MT Bold"
        static let fontSize:CGFloat = 68
        static let fontSize2: CGFloat = 40

        static let name1 = "A"
        static let name2 = "Ad"
        static let name3 = "Adw"
        static let name4 = "Adwu"
        static let name5 = "Adwum"
        static let name6 = "Adwuma"

    }

}
