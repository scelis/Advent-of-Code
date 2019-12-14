//
//  Coordinate3D.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/12/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public struct Coordinate3D: Hashable {
    public var x: Int
    public var y: Int
    public var z: Int

    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    public static let zero = Coordinate3D(x: 0, y: 0, z: 0)

    public static func == (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}
