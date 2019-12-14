import AdventKit
import Foundation

enum Tile: Int {
    case empty = 0
    case wall = 1
    case block = 2
    case horizontalPaddle = 3
    case ball = 4
}

func part1(input: [Int]) -> Int {
    let computer = IntcodeComputer(memory: input)
    computer.run()

    var output: [Coordinate: Tile] = [:]
    for instruction in computer.outputBuffer.chunked(into: 3) {
        let coordinate = Coordinate(x: instruction[0], y: instruction[1])
        output[coordinate] = Tile(rawValue: instruction[2])
    }

    return output.values.reduce(0) { (result, tile) -> Int in
        return (tile == .block) ? result + 1 : result
    }
}

func part2(input: [Int]) -> Int {
    let computer = IntcodeComputer(memory: input)
    computer[0] = 2
    computer.run()

    var score = 0
    var ballPosition: Coordinate?
    var paddlePosition: Coordinate?
    var blockPositions: Set<Coordinate> = []
    while true {
        for instruction in computer.outputBuffer.chunked(into: 3) {
            let coordinate = Coordinate(x: instruction[0], y: instruction[1])
            if coordinate == Coordinate(x: -1, y: 0) {
                score = instruction[2]
            } else {
                let tile = Tile(rawValue: instruction[2])!
                if tile == .ball {
                    ballPosition = coordinate
                }
                if tile == .horizontalPaddle {
                    paddlePosition = coordinate
                }
                if tile == .block {
                    blockPositions.insert(coordinate)
                } else {
                    blockPositions.remove(coordinate)
                }
            }
        }
        computer.outputBuffer = []

        if
            !blockPositions.isEmpty,
            computer.state == .awaitingInput,
            let ballPosition = ballPosition,
            let paddlePosition = paddlePosition
        {
            if ballPosition.x < paddlePosition.x {
                computer.run(input: [-1])
            } else if ballPosition.x > paddlePosition.x {
                computer.run(input: [1])
            } else {
                computer.run(input: [0])
            }
        } else {
            break
        }
    }

    return score
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
print("\(part1(input: integers))")
print("\(part2(input: integers))")
