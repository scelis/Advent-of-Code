import AdventKit
import Foundation

extension CardinalDirection {
    var command: Int {
        switch self {
        case .north: return 1
        case .south: return 2
        case .west: return 3
        case .east: return 4
        }
    }
}

//func direction(from: Coordinate, to: Coordinate) -> CardinalDirection? {
//    if from.x < to.x { return .east }
//    if from.x > to.x { return .west }
//    if from.y > to.y { return .north }
//    if from.y < to.y { return .south }
//    return nil
//}

struct Node {
    enum NodeType: Int {
        case wall = 0
        case floor = 1
        case oxygenSystem = 2
    }

    var coordinate: Coordinate
    var type: NodeType
    var distance: Int
    var path: [CardinalDirection]

    var reversePath: [CardinalDirection] {
        return path.map { $0.opposite }.reversed()
    }
}

class Day15 {
    let computer: IntcodeComputer
    var coordinates: [Coordinate: Node] = [:]
    var unexplored: [Node] = []
    var currentNode: Node
    var oxygenSystem: Node?
    var home: Coordinate = .zero

    init(intcode: [Int]) {
        self.computer = IntcodeComputer(memory: intcode)

        currentNode = Node(coordinate: .zero, type: .floor, distance: 0, path: [])
        coordinates[currentNode.coordinate] = currentNode
        unexplored.append(currentNode)
    }

    func travel(to node: Node) {
        guard currentNode.coordinate != node.coordinate else { return }

        // Travel home
        if currentNode.coordinate != home {
            for direction in currentNode.reversePath {
                computer.run(input: [direction.command])
            }
            currentNode = coordinates[home]!
            computer.outputBuffer = []
        }

        // Travel to node
        for direction in node.path {
            computer.run(input: [direction.command])
        }
        currentNode = node
        computer.outputBuffer = []
    }

    func explore(node: Node) {
        travel(to: node)

        for direction in CardinalDirection.allCases {
            let nextCoordinate = node.coordinate.step(inCardinalDirection: direction)
            if coordinates[nextCoordinate] == nil {
                var newNode = node
                newNode.coordinate = nextCoordinate
                newNode.distance += 1
                newNode.path.append(direction)
                computer.run(input: [direction.command])
                newNode.type = Node.NodeType(rawValue: computer.readInt()!)!
                coordinates[nextCoordinate] = newNode

                switch newNode.type {
                case .floor:
                    unexplored.append(newNode)
                    computer.run(input: [direction.opposite.command])
                    computer.outputBuffer = []
                case .oxygenSystem:
                    oxygenSystem = newNode
                    unexplored.append(newNode)
                    computer.run(input: [direction.opposite.command])
                    computer.outputBuffer = []
                case .wall:
                    break
                }
            }
        }
    }

    func run() {
        while oxygenSystem == nil {
            let unexploredNode = unexplored.removeFirst()
            explore(node: unexploredNode)
        }

        print("Part 1: \(oxygenSystem!.distance)")

        travel(to: oxygenSystem!)
        home = oxygenSystem!.coordinate
        oxygenSystem?.distance = 0
        oxygenSystem?.path = []
        coordinates = [oxygenSystem!.coordinate: oxygenSystem!]
        unexplored = [oxygenSystem!]
        while !unexplored.isEmpty {
            let unexploredNode = unexplored.removeFirst()
            explore(node: unexploredNode)
        }

        let totalTime = coordinates.values.reduce(0) { (result, node) -> Int in
            return max(result, (node.type == .floor) ? node.distance : 0)
        }
        print("Part 2: \(totalTime)")
    }
}


let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
Day15(intcode: integers).run()
