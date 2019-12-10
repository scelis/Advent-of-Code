//
//  Geometry.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/10/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public func rad2deg(_ number: Double) -> Double {
    return number * 180 / .pi
}

public func deg2rad(_ number: Double) -> Double {
    return number * .pi / 180
}

public func areaOfTriangle(a: Coordinate, b: Coordinate, c: Coordinate) -> Double {
    let p1 = a.x * (b.y - c.y)
    let p2 = b.x * (c.y - a.y)
    let p3 = c.x * (a.y - b.y)
    return abs(Double(p1 + p2 + p3)) / 2
}
