//
//  GlobalView.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-09-15.
//

import SwiftUI

struct GlobalView: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var store: SharedStore
    
    var body: some View {
        switch router.currentRoute {
        case .start:
            Start()
        case .home:
            Home()
        }
    }
}

struct GlobalView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView()
            .environmentObject(ViewRouter())
            .environmentObject(SharedStore())
    }
}
