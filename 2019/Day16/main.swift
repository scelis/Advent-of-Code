import AdventKit
import Foundation

func part1(input: [Int], phases: Int = 100) -> Int {
    var input = input
    let pattern = [0, 1, 0, -1]

    for _ in 0..<phases {
        for digitIndex in 0..<input.count {
            var sum = 0
            for patternIndex in digitIndex..<input.count {
                let actualPatternIndex = ((patternIndex + 1) / (digitIndex + 1)) % pattern.count
                let patternValue = pattern[actualPatternIndex]
                let digitValue = input[patternIndex]
                sum += digitValue * patternValue
            }
            input[digitIndex] = abs(sum) % 10
        }
    }

    return Int(input[0..<8].map({ "\($0)" }).joined())!
}

func part2(input: [Int], phases: Int = 100) -> Int {
    var input = Array<[Int]>.init(repeating: input, count: 10000).flatMap({ $0 })
    let startIndex = Int(Array(input.prefix(7)).map({ "\($0)" }).joined())!

    for _ in 0..<phases {
        for i in (startIndex..<input.count - 2).reversed() {
            input[i] = (input[i] + input[i + 1]) % 10
        }
    }

    return Int(input[startIndex..<(startIndex + 8)].map({ "\($0)" }).joined())!
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let numbers: [Int] = input.map( { Int(String($0))! })
let result1 = part1(input: numbers)
print("Part 1: \(result1)")

let result2 = part2(input: numbers)
print("Part 2: \(result2)")
