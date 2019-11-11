//
//  main.swift
//  Day08
//
//  Created by Sebastian Celis on 11/11/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import AdventKit
import Foundation

let input = Advent.contentsOfFile(withName: "input.txt")!
let components = input.components(separatedBy: " ").map({ Int($0)! })

func sumOfMetadata(
    components: [Int],
    currentPosition: Int = 0)
    -> (sum: Int, finalPosition: Int)
{
    var i = currentPosition
    var sum = 0

    let numberOfChildNodes = components[i]
    let numberOfMetadataEntries = components[i + 1]
    i += 2

    for _ in 0..<numberOfChildNodes {
        let (a, b) = sumOfMetadata(components: components, currentPosition: i)
        sum += a
        i = b
    }

    for _ in 0..<numberOfMetadataEntries {
        sum += components[i]
        i += 1
    }

    return (sum, i)
}

let part1 = sumOfMetadata(components: components)
print("Part 1: \(part1.sum)")

func valueOfNode(
    components: [Int],
    currentPosition: Int = 0)
    -> (value: Int, finalPosition: Int)
{
    var i = currentPosition
    var value = 0

    let numberOfChildNodes = components[i]
    let numberOfMetadataEntries = components[i + 1]
    i += 2

    var childValues: [Int] = []
    for _ in 0..<numberOfChildNodes {
        let (a, b) = valueOfNode(components: components, currentPosition: i)
        childValues.append(a)
        i = b
    }

    for _ in 0..<numberOfMetadataEntries {
        if numberOfChildNodes == 0 {
            value += components[i]
        } else {
            value += childValues[safe: components[i] - 1] ?? 0
        }
        i += 1
    }

    return (value, i)
}

let part2 = valueOfNode(components: components)
print("Part 2: \(part2.value)")
