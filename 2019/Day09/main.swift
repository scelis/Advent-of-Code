import AdventKit
import Foundation

func run(memory: [Int], input: [Int] = []) -> [Int] {
    let computer = IntcodeComputer(memory: memory)
    computer.run(input: input)
    return computer.outputBuffer
}

print("Example 1: \(run(memory: [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]))")
print("Example 2: \(run(memory: [1102,34915192,34915192,7,4,7,99,0]))")
print("Example 3: \(run(memory: [104,1125899906842624,99]))")

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
print("Part 1: \(run(memory: integers, input: [1]))")
print("Part 2: \(run(memory: integers, input: [2]))")
