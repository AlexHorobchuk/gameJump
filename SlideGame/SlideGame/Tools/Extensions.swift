//
//  Extensions.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/5/23.
//

import Foundation

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
    func middlePosition(between point: CGPoint) -> CGPoint {
        let positionX = (point.x + x) / 2
        let positionY = (point.y + y) / 2
        return CGPoint(x: positionX, y: positionY)
    }
}
