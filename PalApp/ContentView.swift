//
//  ContentView.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.32))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
