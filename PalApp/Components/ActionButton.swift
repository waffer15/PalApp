//
//  ActionButton.swift
//  Botox App
//
//  Created by Rhys Mackenzie on 2022-09-12.
//

import SwiftUI

struct ActionButton: View {
    let lightText = Color.white
    let darkText = Color(hue: 1.0, saturation: 0.0, brightness: 0.36)
    var label: String
    var theme = "blue"
    var action: () -> Void
    
    var body: some View {
        let textColor = theme == "light" ? darkText : lightText
        
        Button(action: action) {
            Text(label)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(theme: theme))
    }
}


struct ActionButtonStyle: ButtonStyle {
    let blueColor = Color(hue: 0.57, saturation: 0.76, brightness: 1.0)
    let lightColor = Color.white
    let cornerRadius = 20.0
    var theme = "blue"

    func makeBody(configuration: Self.Configuration) -> some View {
        let bgColor = theme == "light" ? lightColor : blueColor
        let lineWidth = theme == "light" ? 1.0 : 1.0
        
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.white)
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.black, lineWidth: lineWidth)
                    )
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(label: "I'm feeling Happy") {
            print("test")
        }
    }
}
