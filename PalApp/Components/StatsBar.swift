//
//  StatsBar.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import SwiftUI

struct StatsBar: View {
    @State var palStats: [PalStat]
    var body: some View {
        HStack {
            ForEach(palStats, id: \.title) { palStat in
                ProgressIndicator(palStat: palStat, width: 50)
            }
        }
    }
}

struct StatsBar_Previews: PreviewProvider {
    @State static var palStats = [
        PalStat(title: "Hunger", value: 500, goalValue: 600),
        PalStat(title: "Energy", value: 300, goalValue: 600),
        PalStat(title: "Fitness", value: 25, goalValue: 30)
    ]
    static var previews: some View {
        StatsBar(palStats: palStats)
    }
}
