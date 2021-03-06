import AdventKit
import Foundation

class Day05: Day {
    func seatID(for pass: String) -> Int {
        var low = 0
        var high = 128
        var left = 0
        var right = 8

        for character in pass {
            switch character {
            case "F":
                high = high - ((high - low) / 2)
            case "B":
                low = low + ((high - low + 1) / 2)
            case "L":
                right = right - ((right - left) / 2)
            case "R":
                left = left + ((right - left + 1) / 2)
            default:
                break
            }
        }

        return low * 8 + left
    }

    override func part1() -> String {
        return inputLines
            .map({ seatID(for: $0) })
            .reduce(0, max)
            .description
    }

    override func part2() -> String {
        let ids = inputLines.map({ seatID(for: $0) })
        let set = Set<Int>(ids)
        for i in (set.min()! + 1)..<set.max()! {
            if !set.contains(i) {
                return "\(i)"
            }
        }
        return ""
    }
}

assert(Day05().seatID(for: "FBFBBFFRLR") == 357)
assert(Day05().seatID(for: "BFFFBBFRRR") == 567)
assert(Day05().seatID(for: "FFFBBBFRRR") == 119)
assert(Day05().seatID(for: "BBFFBBFRLL") == 820)

Day05().run()
