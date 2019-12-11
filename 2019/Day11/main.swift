import AdventKit
import Foundation

enum Color: Int {
    case black = 0
    case white = 1
}

class Robot {
    let computer: IntcodeComputer
    var direction = Direction.up
    var coordinate = Coordinate(x: 0, y: 0)
    var coordinatesPainted: [Coordinate: Color] = [:]

    init(input: [Int]) {
        computer = IntcodeComputer(memory: input)
    }

    func part1() -> Int {
        run()

        return coordinatesPainted.count
    }

    func part2() -> String {
        coordinatesPainted[coordinate] = .white
        run()

        let top = coordinatesPainted.keys.min { a, b -> Bool in
            return a.y < b.y
        }
        let bottom = coordinatesPainted.keys.max { a, b -> Bool in
            return a.y < b.y
        }
        let left = coordinatesPainted.keys.min { a, b -> Bool in
            return a.x < b.x
        }
        let right = coordinatesPainted.keys.max { a, b -> Bool in
            return a.x < b.x
        }

        var output = ""
        for y in top!.y...bottom!.y {
            for x in left!.x...right!.x {
                let color = coordinatesPainted[Coordinate(x: x, y: y)] ?? .black
                output += (color == .black) ? "⬛️" : "⬜️"
            }
            output += "\n"
        }

        return output
    }

    private func run() {
        computer.run()

        while computer.state != .halted {
            while computer.outputBuffer.count >= 2 {
                let color = Color(rawValue: computer.readInt()!)
                coordinatesPainted[coordinate] = color
                let turn = computer.readInt()!
                if turn == 0 {
                    direction = direction.turnLeft()
                } else {
                    direction = direction.turnRight()
                }
                coordinate = coordinate.step(inDirection: direction)
            }

            if computer.state == .awaitingInput {
                let color = coordinatesPainted[coordinate] ?? .black
                computer.run(input: [color.rawValue])
            }
        }
    }
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
let part1 = Robot(input: integers)
print("Part 1: \(part1.part1())")

let part2 = Robot(input: integers)
print("Part 2:\n\(part2.part2())")
