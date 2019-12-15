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

    public static let zero = Coordinate(x: 0, y: 0)

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

    public func step(inDirection direction: Direction, distance: Int = 1) -> Coordinate {
        return Coordinate(x: x + direction.dx * distance, y: y + direction.dy * distance)
    }

    public func step(inCardinalDirection direction: CardinalDirection, distance: Int = 1) -> Coordinate {
        return Coordinate(x: x + direction.dx * distance, y: y + direction.dy * distance)
    }
}

public extension Collection where Element == Coordinate {
    var top: Coordinate? {
        return self.min { a, b -> Bool in
            return a.y < b.y
        }
    }

    var bottom: Coordinate? {
        return self.max { a, b -> Bool in
            return a.y < b.y
        }
    }

    var left: Coordinate? {
        return self.min { a, b -> Bool in
            return a.x < b.x
        }
    }

    var right: Coordinate? {
        return self.max { a, b -> Bool in
            return a.x < b.x
        }
    }
}
