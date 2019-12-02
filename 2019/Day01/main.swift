import AdventKit
import Foundation

let lines = Advent.readLinesOfFile(withName: "input.txt")

func part1(lines: [String]) -> Int {
    return lines.compactMap({ Int($0) }).reduce(0) { total, mass in
        return total + mass / 3 - 2
    }
}

print("Part 1: \(part1(lines: lines))")

func fuelRequired(forItemWithMass mass: Int) -> Int {
    guard mass > 0 else { return 0 }
    let fuel = max(0, mass / 3 - 2)
    return fuel + fuelRequired(forItemWithMass: fuel)
}

func part2(lines: [String]) -> Int {
    return lines.compactMap({ Int($0) }).reduce(0) { total, mass in
        return total + fuelRequired(forItemWithMass: mass)
    }
}

print("Part 2: \(part2(lines: lines))")
