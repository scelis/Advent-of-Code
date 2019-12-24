//
//  Maze.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/23/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public protocol TileType {
    var isTraversible: Bool { get }
}

public protocol Maze {
    associatedtype Tile: TileType
    typealias TileMap = [[Int]: Tile]
    var map: TileMap { get }
    func coordinatesReachable(from: [Int]) -> [[Int]]
}

public extension Maze {
    static func parseBasicMap(input: String, tileForCharacter: ((Character) -> Tile)) -> TileMap {
        var map: TileMap = [:]

        var x = 0, y = 0
        for line in input.components(separatedBy: .newlines) {
            for character in line {
                map[[x, y]] = tileForCharacter(character)
                x += 1
            }
            x = 0
            y += 1
        }

        return map
    }

    func coordinatesReachable(from: [Int]) -> [[Int]] {
        var reachable: [[Int]] = []

        for i in 0..<from.count {
            var tmp = from
            tmp[i] += 1
            if map[tmp]?.isTraversible == true {
                reachable.append(tmp)
            }
            tmp[i] -= 2
            if map[tmp]?.isTraversible == true {
                reachable.append(tmp)
            }
        }

        return reachable
    }

    func path(from: [Int], to: [Int]) -> [[Int]]? {
        var unexplored: [[Int]] = [from]
        var paths: [[Int]: [[Int]]] = [:]
        paths[from] = []

        unexplored: while !unexplored.isEmpty {
            let locationToExplore = unexplored.removeFirst()
            let pathToLocation = paths[locationToExplore]!
            for adjacentLocation in coordinatesReachable(from: locationToExplore) {
                if paths[adjacentLocation] == nil {
                    paths[adjacentLocation] = pathToLocation + [adjacentLocation]
                    unexplored.append(adjacentLocation)
                    if adjacentLocation == to {
                        break unexplored
                    }
                }
            }
        }

        return paths[to]
    }

    func distance(from: [Int], to: [Int]) -> Int? {
        return path(from: from, to: to)?.count
    }
}
