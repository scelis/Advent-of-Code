//
//  CardinalDirection.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/15/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public enum CardinalDirection: CaseIterable {
    case north
    case south
    case east
    case west

    public var dx: Int {
        switch self {
        case .north, .south: return 0
        case .west: return -1
        case .east: return 1
        }
    }

    public var dy: Int {
        switch self {
        case .north: return -1
        case .south: return 1
        case .west, .east: return 0
        }
    }

    public var opposite: CardinalDirection {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
}
