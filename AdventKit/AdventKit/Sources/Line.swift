//
//  Line.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/3/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public struct Line {
    public var coordinate1: Coordinate
    public var coordinate2: Coordinate

    public init(coordinate1: Coordinate, coordinate2: Coordinate) {
        self.coordinate1 = coordinate1
        self.coordinate2 = coordinate2
    }
}
