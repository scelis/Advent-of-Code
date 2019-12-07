import AdventKit
import Foundation

func part1(memory: [Int]) -> Int {
    var maxSignal = Int.min
    for a in 0...4 {
        for b in 0...4 {
            for c in 0...4 {
                for d in 0...4 {
                    for e in 0...4 {
                        let set: Set<Int> = [a, b, c, d, e]
                        if set.count == 5 {
                            let computerA = IntcodeComputer(memory: memory)
                            computerA.run(input: [a, 0])
                            let computerB = IntcodeComputer(memory: memory)
                            computerB.run(input: [b, computerA.readInt()!])
                            let computerC = IntcodeComputer(memory: memory)
                            computerC.run(input: [c, computerB.readInt()!])
                            let computerD = IntcodeComputer(memory: memory)
                            computerD.run(input: [d, computerC.readInt()!])
                            let computerE = IntcodeComputer(memory: memory)
                            computerE.run(input: [e, computerD.readInt()!])
                            maxSignal = max(maxSignal, computerE.readInt()!)
                        }
                    }
                }
            }
        }
    }

    return maxSignal
}

func part2(memory: [Int]) -> Int {
    var maxSignal = Int.min
    for a in 5...9 {
        for b in 5...9 {
            for c in 5...9 {
                for d in 5...9 {
                    for e in 5...9 {
                        let set: Set<Int> = [a, b, c, d, e]
                        if set.count == 5 {
                            var computers: [IntcodeComputer] = []
                            for _ in 0...4 {
                                computers.append(IntcodeComputer(memory: memory))
                            }

                            computers[0].run(input: [a, 0])
                            computers[1].run(input: [b])
                            computers[2].run(input: [c])
                            computers[3].run(input: [d])
                            computers[4].run(input: [e])

                            while computers.last!.state != .halted {
                                for (index, computer) in computers.enumerated() {
                                    let previousIndex = (index > 0) ? index - 1 : 4
                                    let previousComputer = computers[previousIndex]
                                    if
                                        computer.state == .awaitingInput,
                                        let output = previousComputer.readInt()
                                    {
                                        computer.run(input: [output])
                                    }
                                }
                            }
                            maxSignal = max(maxSignal, computers.last!.readInt()!)
                        }
                    }
                }
            }
        }
    }

    return maxSignal
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
let output1 = part1(memory: integers)
print("Part 1: \(output1)")
let output2 = part2(memory: integers)
print("Part 2: \(output2)")
