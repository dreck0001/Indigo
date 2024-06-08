//
//  BaseView.swift
//  Indigo
//
//  Created by Denis on 6/5/24.
//

import SwiftUI

struct BaseView: View {

    @State var contentTyoe: contentType
    
    var body: some View {
        VStack {
            Spacer()
            switch contentTyoe {
            case .Colors, .Shapes, .Photos, .Objects:
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 1500, height: 600)
            default:
                Text("Subject item")
            }
            Text("Item name")
            Spacer()
            HStack {
                Text("Previus").button1()
                
                Text("Next").button1()
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Button")
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Button")
                })
                
            }
        }
    }
}

enum contentType {
    case Alphabets
    case Numbers
    case Colors
    case Shapes
    case Photos
    case Objects
    case Random
}

#Preview { BaseView(contentTyoe: .Colors) }
#Preview { BaseView(contentTyoe: .Alphabets) }

