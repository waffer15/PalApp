//
//  ProgressIndicator.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import SwiftUI

struct ProgressIndicator: View {
    @State var palStat: PalStat
    var width: Float = 100.0
    
    var progress: CGFloat {
        if palStat.goalValue == 0 {
            return 0.0
        }
        return palStat.value / palStat.goalValue
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(Color(hue: 1.0, saturation: 0.0, brightness: 0.937), lineWidth: 12.0)
                .frame(width: CGFloat(width), height: CGFloat(width * 4/3))
                .rotationEffect(Angle(degrees: -180))
            Circle()
                .trim(from: 0.0, to: min(progress / 2, 0.5))
                .stroke(palStat.color, lineWidth: 12.0)
                .frame(width: CGFloat(width), height: CGFloat(width * 4/3))
                .rotationEffect(Angle(degrees: -180))
                .padding()
            Text("\(String(format: "%.0f", progress * 100))%")
                .font(.system(size: 10))
                .padding(.bottom)
            Text(palStat.title)
                .padding(.top, 25.0)
        }
    }
}

struct ProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicator(palStat: PalStat(title: "Hunger", value: 460, goalValue: 690), width: 50)
    }
}
