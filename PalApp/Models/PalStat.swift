//
//  PalStat.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import Foundation
import SwiftUI

class PalStat: ObservableObject {
    static func == (lhs: PalStat, rhs: PalStat) -> Bool {
        return lhs.title == rhs.title
    }
    
    @Published var title: String
    @Published var value: Double
    @Published var goalValue: Double
    @Published var color: Color
    
    init(title: String, value: Double, goalValue: Double, color: Color = .blue) {
        self.title = title
        self.value = value
        self.goalValue = goalValue
        self.color = color
    }
}
