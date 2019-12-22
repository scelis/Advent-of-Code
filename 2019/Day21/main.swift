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

func part2(intcode: [Int]) {
    let computer = IntcodeComputer(memory: intcode)
    computer.run(input: [])
    computer.printOutputAsAscii()

    // Only jump if there is a hole to jump over and we can see another safe jump in the future
    // if (!A || !B || !C) && (D) && (H || (E && I)
    computer.run(asciiCommand: "OR E J")
    computer.run(asciiCommand: "AND I J")
    computer.run(asciiCommand: "OR H J")
    computer.run(asciiCommand: "AND D J")
    computer.run(asciiCommand: "OR A T")
    computer.run(asciiCommand: "AND B T")
    computer.run(asciiCommand: "AND C T")
    computer.run(asciiCommand: "NOT T T")
    computer.run(asciiCommand: "AND T J")

    // if !A, jump even if we can't see far enough ahead for a safe second jump
    computer.run(asciiCommand: "NOT A T")
    computer.run(asciiCommand: "OR T J")

    computer.run(asciiCommand: "RUN")

    computer.printOutputAsAscii()
    if let result = computer.readInt() {
        print("Part 2: \(result)")
    }
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
part1(intcode: integers)
part2(intcode: integers)
