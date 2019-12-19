import AdventKit
import Foundation

class Day19 {
    let input: [Int]

    init(input: [Int]) {
        self.input = input
    }

    func part1() {
        var count = 0
        for x in 0..<50 {
            for y in 0..<50 {
                let computer = IntcodeComputer(memory: input)
                computer.run(input: [x, y])
                let output = computer.readInt()!
                if output == 1 {
                    count += 1
                }
            }
        }

        print("Part 1: \(count)")
    }

    func part2() {
        var ranges: [Int: IndexSet] = [:]
        var x = 0
        var y = 100
        var beginX: Int?
        var endX: Int?

        while true {
            let computer = IntcodeComputer(memory: input)
            computer.run(input: [x, y])

            if computer.readInt()! == 1 {
                if beginX == nil {
                    beginX = x
                    endX = x
                } else {
                    endX = x
                }

                x += 1
            } else if
                let theBeginX = beginX,
                let theEndX = endX
            {
                let indexSet = IndexSet(integersIn: theBeginX...theEndX)
                ranges[y] = indexSet

                if
                    let prevSet = ranges[y - 99],
                    case let intersection = prevSet.intersection(indexSet),
                    intersection.count >= 100
                {
                    let minX = intersection.min()!
                    let result = minX * 10000 + (y - 99)
                    print("Part 2: \(result)")
                    return
                }

                y += 1
                x = theBeginX
                beginX = nil
                endX = nil
            } else {
                x += 1
            }
        }
    }

    func run() {
        part1()
        part2()
    }
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
let day19 = Day19(input: integers)
day19.run()
