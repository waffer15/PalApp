//
//  Start.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-09.
//

import SwiftUI

struct Start: View {
    @EnvironmentObject var store: SharedStore
    @EnvironmentObject var router: ViewRouter
    
    var body: some View {
        Text("Pal")
        Spacer()
        ActionButton(label: "Start") {
            self.router.currentRoute = .home   
        }
        .padding()
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        Start()
    }
}
