//
//  AppDelegate.swift
//  Day06
//
//  Created by Sebastian Celis on 11/11/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import AdventKit
import Foundation

var coordinates: Set<Coordinate> = []
for line in Advent.readLinesOfFile(withName: "input.txt") {
    let components = line.components(separatedBy: ", ")
    coordinates.insert(Coordinate(x: Int(components[0])!, y: Int(components[1])!))
}

var minimum = Coordinate(x: Int.max, y: Int.max)
var maximum = Coordinate(x: Int.min, y: Int.min)
for coordinate in coordinates {
    minimum.x = min(minimum.x, coordinate.x)
    minimum.y = min(minimum.y, coordinate.y)
    maximum.x = max(maximum.x, coordinate.x)
    maximum.y = max(maximum.y, coordinate.y)
}

var areas: [Coordinate: Int] = [:]
var infinites: Set<Coordinate> = []
for x in minimum.x...maximum.x {
    for y in minimum.y...maximum.y {
        let tmpCoordinate = Coordinate(x: x, y: y)
        var closestDistance = Int.max
        var closestCoordinate: Coordinate?

        for coordinate in coordinates {
            let distance = coordinate.manhattanDistance(from: tmpCoordinate)
            if distance < closestDistance {
                closestDistance = distance
                closestCoordinate = coordinate
            } else if distance == closestDistance {
                closestCoordinate = nil
            }
        }

        if let closestCoordinate = closestCoordinate {
            areas[closestCoordinate] = (areas[closestCoordinate] ?? 0) + 1

            if x == minimum.x || x == maximum.x || y == minimum.y || y == maximum.y {
                infinites.insert(closestCoordinate)
            }
        }
    }
}

var maxArea = Int.min
areas.forEach { coordinate, area in
    if
        !infinites.contains(coordinate),
        area > maxArea
    {
        maxArea = area
    }
}
print("Part 1: \(maxArea)")

let maximumDistance = 10000
var area = 0
for x in minimum.x...maximum.x {
    for y in minimum.y...maximum.y {
        let tmpCoordinate = Coordinate(x: x, y: y)
        var totalDistance = 0

        for coordinate in coordinates {
            totalDistance += coordinate.manhattanDistance(from: tmpCoordinate)
        }

        if totalDistance <= maximumDistance {
            area += 1
        }
    }
}
print("Part 2: \(area)")
