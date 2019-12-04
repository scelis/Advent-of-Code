//
//  Int+Extensions.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/4/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public extension Int {
    var digits: [Int] {
        var digits: [Int] = []
        var number = self

        while number != 0 {
            let ones = number % 10
            digits.insert(ones, at: 0)
            number = number / 10
        }

        return digits
    }
}
