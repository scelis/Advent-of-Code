//
//  Array+Extensions.swift
//  AdventKit
//
//  Created by Sebastian Celis on 11/11/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
