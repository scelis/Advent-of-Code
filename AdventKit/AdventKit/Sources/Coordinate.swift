//
//  Coordinate.swift
//  AdventKit
//
//  Created by Sebastian Celis on 11/11/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public struct Coordinate: Hashable {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    public func manhattanDistance(from: Coordinate) -> Int {
        return abs(x - from.x) + abs(y - from.y)
    }

    public func step(inDirection direction: Direction) -> Coordinate {
        return Coordinate(x: x + direction.dx, y: y + direction.dy)
    }
}
