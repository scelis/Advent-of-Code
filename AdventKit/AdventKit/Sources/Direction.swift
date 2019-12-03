//
//  Direction.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/3/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public enum Direction: String {
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
}
