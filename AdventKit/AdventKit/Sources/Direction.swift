//
//  Direction.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/3/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public enum Direction: String, CaseIterable {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"

    public var dx: Int {
        switch self {
        case .up, .down: return 0
        case .left: return -1
        case .right: return 1
        }
    }

    public var dy: Int {
        switch self {
        case .up: return -1
        case .down: return 1
        case .left, .right: return 0
        }
    }

    public func turnRight() -> Direction {
        switch self {
        case .up: return .right
        case .right: return .down
        case .down: return .left
        case .left: return .up
        }
    }

    public func turnLeft() -> Direction {
        switch self {
        case .up: return .left
        case .right: return .up
        case .down: return .right
        case .left: return .down
        }
    }
}
