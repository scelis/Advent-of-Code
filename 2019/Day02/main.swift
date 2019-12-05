import AdventKit
import Foundation

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })

func runComputer(noun: Int, verb: Int) -> Int {
    let computer = IntcodeComputer(memory: integers)
    computer.memory[1] = noun
    computer.memory[2] = verb
    _ = computer.run()
    return computer.memory[0]
}

func part1() -> Int {
    return runComputer(noun: 12, verb: 2)
}

func part2() -> Int {
    let desired = 19690720

    for noun in 0...99 {
        for verb in 0...99 {
            let computer = IntcodeComputer(memory: integers)
            computer.memory[1] = noun
            computer.memory[2] = verb

            if runComputer(noun: noun, verb: verb) == desired {
                return 100 * noun + verb
            }
        }
    }

    return -1
}

print("Part 1: \(part1())")
print("Part 2: \(part2())")
