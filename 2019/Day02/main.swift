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
        let opcode = Opcode(rawValue: integers[position])!

        if opcode == .halt {
            break
        }

        let pos1 = integers[position + 1]
        let pos2 = integers[position + 2]
        let pos3 = integers[position + 3]
        let val1 = integers[pos1]
        let val2 = integers[pos2]

        if opcode == .add {
            integers[pos3] = val1 + val2
        } else if opcode == .multiply {
            integers[pos3] = val1 * val2
        }

        position += 4
    }

    return integers[0]
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
