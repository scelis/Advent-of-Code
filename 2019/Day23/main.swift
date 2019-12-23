import AdventKit
import Foundation

class Day23 {
    var computers: [IntcodeComputer] = []
    var inputQueue: [Int: [Coordinate]] = [:]
    var natPacket: Coordinate?
    var lastNatPacket: Coordinate?

    init(intcode: [Int]) {
        for i in 0..<50 {
            let computer = IntcodeComputer(memory: intcode)
            computer.run(input: [i])
            computers.append(computer)
        }
    }

    func run(part: Int) {
        while true {
            for i in 0..<50 {
                if let input = inputQueue[i]?.first {
                    computers[i].run(input: [input.x, input.y])
                    var queue = inputQueue[i]!
                    queue.remove(at: 0)
                    inputQueue[i] = queue.isEmpty ? nil : queue
                } else {
                    computers[i].run(input: [-1])
                }

                for command in computers[i].outputBuffer.chunked(into: 3) {
                    if command[0] == 255 {
                        if part == 1 {
                            print("Part 1: \(command[2])")
                            return
                        }

                        natPacket = Coordinate(x: command[1], y: command[2])
                    } else {
                        var queue = inputQueue[command[0]] ?? []
                        queue.append(Coordinate(x: command[1], y: command[2]))
                        inputQueue[command[0]] = queue
                    }
                }
                computers[i].clearOutputBuffer()
            }

            if
                part == 2,
                let natPacket = natPacket,
                inputQueue.isEmpty
            {
                if lastNatPacket?.y == natPacket.y {
                    print("Part 2: \(natPacket.y)")
                    return
                }

                inputQueue[0] = [natPacket]
                self.lastNatPacket = natPacket
                self.natPacket = nil
            }
        }
    }
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
Day23(intcode: integers).run(part: 1)
Day23(intcode: integers).run(part: 2)
