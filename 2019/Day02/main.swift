import AdventKit
import Foundation

enum Opcode: Int {
    case add = 1
    case multiply = 2
    case halt = 99
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })

func part1(integers: [Int], noun: Int = 12, verb: Int = 2) -> Int {
    var integers = integers
    var position = 0

    integers[1] = noun
    integers[2] = verb

    while true {
        switch Opcode(rawValue: integers[position])! {
        case .halt:
            return integers[0]
        case .add:
            integers[integers[position + 3]] = integers[integers[position + 1]] + integers[integers[position + 2]]
        case .multiply:
            integers[integers[position + 3]] = integers[integers[position + 1]] * integers[integers[position + 2]]
        }

        position += 4
    }
}

func part2(integers: [Int]) -> Int {
    let desired = 19690720

    for noun in 0...99 {
        for verb in 0...99 {
            if part1(integers: integers, noun: noun, verb: verb) == desired {
                return 100 * noun + verb
            }
        }
    }

    return -1
}

print("Part 1: \(part1(integers: integers))")
print("Part 2: \(part2(integers: integers))")
