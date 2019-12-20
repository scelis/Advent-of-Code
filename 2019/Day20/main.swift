import AdventKit
import Foundation

class Day20 {
    enum Tile {
        case floor
        case teleporter(String)
    }

    struct Node {
        var coordinate: Coordinate
        var tile: Tile
        var distance: Int
        var level: Int
        var path: [Coordinate3D] = []

        init(coordinate: Coordinate, tile: Tile, distance: Int, level: Int = 0) {
            self.coordinate = coordinate
            self.tile = tile
            self.distance = distance
            self.level = level
        }
    }

    let input: String
    var tilesByCoordinate: [Coordinate: Tile] = [:]
    var teleporterCoordinatesByName: [String: Set<Coordinate>] = [:]
    var nodes: [Coordinate: Node] = [:]
    var recursiveNodes: [Coordinate3D: Node] = [:]
    var unexplored: [Node] = []
    var finalNode: Node?

    init(input: String) {
        self.input = input
    }

    func parseInput() {
        let characters: [[Character]] = input
            .components(separatedBy: .newlines)
            .filter({ !$0.isEmpty })
            .map({ Array($0) })

        for (y, row) in characters.enumerated() {
            for (x, character) in row.enumerated() {
                let coordinate = Coordinate(x: x, y: y)

                switch character {
                case " ":
                    break
                case ".":
                    let tile: Tile
                    if
                        let first = characters[safe: y]?[safe: x - 2],
                        let second = characters[safe: y]?[safe: x - 1],
                        first >= "A" && first <= "Z",
                        second >= "A" && second <= "Z"
                    {
                        tile = .teleporter(String(first) + String(second))
                    } else if
                        let first = characters[safe: y]?[safe: x + 1],
                        let second = characters[safe: y]?[safe: x + 2],
                        first >= "A" && first <= "Z",
                        second >= "A" && second <= "Z"
                    {
                        tile = .teleporter(String(first) + String(second))
                    } else if
                        let first = characters[safe: y - 2]?[safe: x],
                        let second = characters[safe: y - 1]?[safe: x],
                        first >= "A" && first <= "Z",
                        second >= "A" && second <= "Z"
                    {
                        tile = .teleporter(String(first) + String(second))
                    } else if
                        let first = characters[safe: y + 1]?[safe: x],
                        let second = characters[safe: y + 2]?[safe: x],
                        first >= "A" && first <= "Z",
                        second >= "A" && second <= "Z"
                    {
                        tile = .teleporter(String(first) + String(second))
                    } else {
                        tile = .floor
                    }

                    if case .teleporter(let name) = tile {
                        var set = teleporterCoordinatesByName[name] ?? []
                        set.insert(coordinate)
                        teleporterCoordinatesByName[name] = set
                    }

                    tilesByCoordinate[coordinate] = tile
                case "#":
                    break // No need to remember walls
                default:
                    break
                }
            }
        }
    }

    func explore(node: Node) {
        for direction in Direction.allCases {
            if
                case let nextCoordinate = node.coordinate.step(inDirection: direction),
                nodes[nextCoordinate] == nil,
                let nextTile = tilesByCoordinate[nextCoordinate]
            {
                let nextNode = Node(coordinate: nextCoordinate, tile: nextTile, distance: node.distance + 1)
                nodes[nextCoordinate] = nextNode
                unexplored.append(nextNode)
            }

            if case .teleporter(let name) = node.tile {
                var teleporterCoordinates = teleporterCoordinatesByName[name]!
                teleporterCoordinates.remove(node.coordinate)
                if
                    let nextCoordinate = teleporterCoordinates.first,
                    nodes[nextCoordinate] == nil,
                    let nextTile = tilesByCoordinate[nextCoordinate]
                {
                    let nextNode = Node(coordinate: nextCoordinate, tile: nextTile, distance: node.distance + 1)
                    nodes[nextCoordinate] = nextNode
                    unexplored.append(nextNode)
                }
            }
        }
    }

    func explore2(node: Node) {
        if
            node.level == 0,
            node.coordinate == teleporterCoordinatesByName["ZZ"]!.first!
        {
            finalNode = node
            return
        }

        for direction in Direction.allCases {
            if
                case let nextCoordinate = node.coordinate.step(inDirection: direction),
                case let nextCoordinate3D = Coordinate3D(x: nextCoordinate.x, y: nextCoordinate.y, z: node.level),
                recursiveNodes[nextCoordinate3D] == nil,
                let nextTile = tilesByCoordinate[nextCoordinate]
            {
                let nextNode = Node(coordinate: nextCoordinate, tile: nextTile, distance: node.distance + 1, level: node.level)
                recursiveNodes[nextCoordinate3D] = nextNode
                unexplored.append(nextNode)
            }

            if case .teleporter(let name) = node.tile {
                var teleporterCoordinates = teleporterCoordinatesByName[name]!
                teleporterCoordinates.remove(node.coordinate)

                if let nextCoordinate = teleporterCoordinates.first {
                    if
                        node.coordinate.y > 15, node.coordinate.y < 115,
                        node.coordinate.x > 25, node.coordinate.x < 110
                    {
                        if
                            case let nextCoordinate3D = Coordinate3D(x: nextCoordinate.x, y: nextCoordinate.y, z: node.level + 1),
                            recursiveNodes[nextCoordinate3D] == nil,
                            let nextTile = tilesByCoordinate[nextCoordinate]
                        {
                            let nextNode = Node(coordinate: nextCoordinate, tile: nextTile, distance: node.distance + 1, level: node.level + 1)
                            recursiveNodes[nextCoordinate3D] = nextNode
                            unexplored.append(nextNode)
                        }
                    } else {
                        if
                            node.level > 0,
                            case let nextCoordinate3D = Coordinate3D(x: nextCoordinate.x, y: nextCoordinate.y, z: node.level - 1),
                            recursiveNodes[nextCoordinate3D] == nil,
                            let nextTile = tilesByCoordinate[nextCoordinate]
                        {
                            let nextNode = Node(coordinate: nextCoordinate, tile: nextTile, distance: node.distance + 1, level: node.level - 1)
                            recursiveNodes[nextCoordinate3D] = nextNode
                            unexplored.append(nextNode)
                        }
                    }
                }
            }
        }
    }

    func part1() {
        let startCoordinate = teleporterCoordinatesByName["AA"]!.first!
        let start = Node(coordinate: startCoordinate, tile: .floor, distance: 0)

        unexplored.append(start)
        while !unexplored.isEmpty {
            let node = unexplored.removeFirst()
            explore(node: node)
        }

        let endCoordinate = teleporterCoordinatesByName["ZZ"]!.first!
        let end = nodes[endCoordinate]!
        print("Part 1: \(end.distance)")
    }

    func part2() {
        let startCoordinate = teleporterCoordinatesByName["AA"]!.first!
        let start = Node(coordinate: startCoordinate, tile: .floor, distance: 0)

        unexplored.append(start)
        while finalNode == nil {
            let node = unexplored.removeFirst()
            explore2(node: node)
        }

        print("Part 2: \(finalNode!.distance)")
    }

    func run() {
        parseInput()
        part1()
        part2()
    }
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let day20 = Day20(input: input)
day20.run()
