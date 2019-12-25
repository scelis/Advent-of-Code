import AdventKit
import Foundation

let commands = [
    "east",
    "take festive hat",
    "east",
    "take food ration",
    "east",
    "take spool of cat6",
    "west",
    "west",
    "west",

    "west",
    "take hologram",
    "north",
    "take space heater",
    "east",
    "take space law space brochure",
    "east",
    "take tambourine",
    "west",
    "west",
    "south",
    "east",

    "east",
    "south",
    "east",
    "east",
    "take fuel cell",
    "east",

    "drop festive hat",
    "drop food ration",
    "drop tambourine",
    "drop fuel cell",
    "south"
]

let items = [
    "festive hat",
    "food ration",
    "spool of cat6",
    "hologram",
    "space heater",
    "space law space brochure",
    "tambourine",
    "fuel cell"
]

let input = Advent.contentsOfFile(withName: "input.txt")!
let integers = input.components(separatedBy: ",").map({ Int($0)! })
let computer = IntcodeComputer(memory: integers)

computer.run()
computer.printOutputAsAscii()

for command in commands {
    print("> \(command)")
    computer.run(asciiCommand: command)
    computer.printOutputAsAscii()
}

for i in 0..<items.count {
    for j in (i + 1)..<items.count {
        for k in (j + 1)..<items.count {
            for l in (k + 1)..<items.count {
                computer.run(asciiCommand: "drop \(items[i])")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "drop \(items[j])")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "drop \(items[k])")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "drop \(items[l])")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "south")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "take \(items[i])")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "take \(items[j])")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "take \(items[k])")
                computer.printOutputAsAscii()
                computer.run(asciiCommand: "take \(items[l])")
                computer.printOutputAsAscii()
            }
        }
    }
}

print("> ", separator: "", terminator: "")
while let command = readLine(strippingNewline: true) {
    computer.run(asciiCommand: command)
    computer.printOutputAsAscii()
    print("\n> ", separator: "", terminator: "")
}
