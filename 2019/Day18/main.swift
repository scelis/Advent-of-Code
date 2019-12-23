import AdventKit
import Foundation

class TritonMaze: Maze {
    enum Tile: TileType, Hashable, CustomDebugStringConvertible {
        case start
        case wall
        case floor
        case key(Character)
        case door(Character)

        var isTraversible: Bool {
            switch self {
            case .start, .floor, .key, .door: return true
            case .wall: return false
            }
        }

        var debugDescription: String {
            switch self {
            case .start: return "@"
            case .door(let character): return character.uppercased()
            case .key(let character): return String(character)
            case .floor: return "."
            case .wall: return "#"
            }
        }
    }

    var map: [[Int]: Tile]

    init(input: String) {
        self.map = TritonMaze.parseBasicMap(input: input, tileForCharacter: { character in
            switch character {
            case "@": return .start
            case "#": return .wall
            case ".": return .floor
            case "a"..."z": return .key(character)
            case "A"..."Z": return .door(Character(character.lowercased()))
            default: fatalError()
            }
        })
    }

    func representation(forKey key: Character) -> Int {
        return 1 << (key.asciiValue! - Character("a").asciiValue!)
    }

    lazy var allKeys: Int = {
        var keys =  0
        for character in "abcdefghijklmnopqrstuvwxytz" {
            keys |= representation(forKey: character)
        }
        return keys
    }()

    var currentDistance = 0

    func run() -> Int {
        func coordinatesReachable(from: [Int]) -> [[Int]] {
            var reachable: [[Int]] = []

            for i in 0..<(from.count - 1) {
                for j in [1, -1] {
                    var tmp = from
                    tmp[i] += j

                    if let tile = map[[tmp[i / 2], tmp[i / 2 + 1]]] {
                        switch tile {
                        case .floor:
                            reachable.append(tmp)
                        case .key(let character):
                            tmp[tmp.count - 1] = tmp[tmp.count - 1] | representation(forKey: character)
                            reachable.append(tmp)
                        case .door(let character):
                            if (tmp[tmp.count - 1] & representation(forKey: character)) != 0 {
                                reachable.append(tmp)
                            }
                        default:
                            break
                        }
                    }
                }
            }

            return reachable
        }

        // Find starting coordinate(s)
        var start: [Int] = []
        for (location, tile) in map {
            if case .start = tile {
                start.append(location[0])
                start.append(location[1])
            }
        }

        // No keys
        start.append(0)

        var unexplored: [[Int]] = [start]
        var distances: [[Int]: Int] = [:]
        distances[start] = 0

        while !unexplored.isEmpty {
            let locationToExplore = unexplored.removeFirst()
            let distance = distances[locationToExplore]!

            if distance > currentDistance {
                currentDistance = distance
                NSLog("Looking at distance \(currentDistance)")
            }

            for adjacentLocation in coordinatesReachable(from: locationToExplore) {
                if distances[adjacentLocation] == nil {
                    distances[adjacentLocation] = distance + 1
                    unexplored.append(adjacentLocation)
                    if adjacentLocation[adjacentLocation.count - 1] == allKeys {
                        return distance + 1
                    }
                }
            }
        }

        return -1
    }
}

let input1 = Advent.contentsOfFile(withName: "input.txt")!
let maze1 = TritonMaze(input: input1)
let answer1 = maze1.run()
print("Part 1: \(answer1)")

let input2 = Advent.contentsOfFile(withName: "input2.txt")!
let maze2 = TritonMaze(input: input2)
let answer2 = maze2.run()
print("Part 2: \(answer2)")
