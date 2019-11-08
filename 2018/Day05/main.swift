//
//  AppDelegate.swift
//  Day05
//
//  Created by Sebastian Celis on 11/8/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import AdventKit
import Foundation

func reducedPolymerLength(input: String) -> Int {
    var history: [String] = []
    for char in input {
        let char = String(char)

        if
            let previous = history.last,
            previous != char,
            previous.lowercased() == char.lowercased()
        {
            _ = history.removeLast()
        } else {
            history.append(char)
        }
    }

    return history.count
}

let input = Advent.contentsOfFile(withName: "input.txt")!.trimmingCharacters(in: .whitespacesAndNewlines)
print("Part 1: \(reducedPolymerLength(input: input))")

let validPolymers = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
var minLength = Int.max
for polymer in validPolymers {
    let reducedInput = input.filter({ $0 != polymer && $0 != Character(polymer.lowercased()) })
    let reducedLength = reducedPolymerLength(input: reducedInput)
    minLength = min(minLength, reducedLength)
}
print("Part 2: \(minLength)")
