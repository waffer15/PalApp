//
//  CGContextExtension.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-21.
//

import Foundation
import SpriteKit
import SwiftUI

extension CGContext {
    static func createArcPathFromBottom(
      arcWidth: CGFloat,
      arcHeight: CGFloat,
      startAngle: Angle,
      endAngle: Angle
    ) -> CGPath {

      let arcRadius = (arcHeight / 2) + pow(arcWidth, 2) / (8 * arcHeight)
      let angle = acos(arcWidth / (2 * arcRadius))
        let startAngle = CGFloat(startAngle.radians) + angle
        let endAngle = CGFloat(endAngle.radians) - angle
      
      let path = CGMutablePath()

      path.addArc(
        center: CGPointZero,
        radius: arcRadius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: false)

      return path.copy()!
    }
}
