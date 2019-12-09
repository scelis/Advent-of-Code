import AdventKit
import Foundation

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })

let part1 = IntcodeComputer(memory: integers)
part1.run(input: [1])
print("Part 1: \(part1.outputBuffer) = 7988899")

let part2 = IntcodeComputer(memory: integers)
part2.run(input: [5])
print("Part 2: \(part2.outputBuffer) = 13758663")
