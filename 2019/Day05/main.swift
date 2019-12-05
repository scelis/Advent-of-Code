import AdventKit
import Foundation

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })

let part1 = IntcodeComputer(memory: integers)
let output1 = part1.run(input: 1)
print("Part 1: \(output1)")

let part2 = IntcodeComputer(memory: integers)
let output2 = part2.run(input: 5)
print("Part 2: \(output2)")
