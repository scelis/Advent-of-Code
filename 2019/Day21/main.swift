import AdventKit
import Foundation

func part1(intcode: [Int]) {
    let computer = IntcodeComputer(memory: intcode)
    computer.run(input: [])
    computer.printOutputAsAscii()
    computer.run(asciiCommand: "NOT C J")
    computer.run(asciiCommand: "NOT A T")
    computer.run(asciiCommand: "OR T J")
    computer.run(asciiCommand: "AND D J")
    computer.run(asciiCommand: "WALK")
    computer.printOutputAsAscii()
    if let result = computer.readInt() {
        print("Part 1: \(result)")
    }
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
part1(intcode: integers)
