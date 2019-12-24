import AdventKit
import Foundation

let debug = false

func biodiversityRating(for string: String) -> Int64 {
    var ptr: Int64 = 1
    var result: Int64 = 0
    for character in string {
        if character == "#" {
            result = result | ptr
            ptr = ptr << 1
        } else if character == "." {
            ptr = ptr << 1
        }
    }
    return result
}

func nextState(for state: Int64) -> Int64 {
    var next: Int64 = 0
    for i in 0..<25 {
        var checks: [Int] = []
        switch i {
        case 0, 5, 10, 15, 20:
            checks = [-5, 1, 5]
        case 4, 9, 14, 19, 24:
            checks = [-5, -1, 5]
        default:
            checks = [-5, -1, 1, 5]
        }

        var numSurrounding = 0
        for j in checks {
            let tmp = i + j
            if tmp >= 0 && tmp <= 24 && ((1 << tmp) & state) != 0 {
                numSurrounding += 1
            }
        }

        if ((1 << i) & state) != 0 {
            if numSurrounding == 1 {
                next = next | (1 << i)
            }
        } else {
            if numSurrounding == 1 || numSurrounding == 2 {
                next = next | (1 << i)
            }
        }
    }

    return next
}

func prettyPrint(state: Int64) {
    var output = ""
    for i in 0..<25 {
        if i > 0 && i % 5 == 0 {
            output += "\n"
        }

        if ((1 << i) & state) != 0 {
            output += "#"
        } else {
            output += "."
        }
    }

    print("")
    print(output)
    print("")
}

func part1(input: String) -> Int64 {
    var state = biodiversityRating(for: input)
    var seen: Set<Int64> = []

    while !seen.contains(state) {
        if debug {
            prettyPrint(state: state)
        }
        seen.insert(state)
        state = nextState(for: state)
    }

    return state
}

let example1 = """
....#
#..#.
#..##
..#..
#....
""".trimmingCharacters(in: .whitespacesAndNewlines)
print("Example 1: \(part1(input: example1))")

let input = Advent.contentsOfFile(withName: "input.txt")!
print("Part 1: \(part1(input: input))")

