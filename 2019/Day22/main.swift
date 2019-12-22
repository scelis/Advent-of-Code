import AdventKit
import Foundation

func part1(input: String, deckSize: Int, deck: [Int]? = nil) -> [Int] {
    var deck: [Int] = deck ?? .init(0..<deckSize)

    input.enumerateLines { line in
        let components = line.components(separatedBy: .whitespaces)
        if line == "deal into new stack" {
            deck = deck.reversed()
        } else if line.starts(with: "cut") {
            var number = Int(components[1])!
            number = number < 0 ? deckSize + number : number
            let top = Array(deck[0..<number])
            let bottom = Array(deck[number..<deck.count])
            deck = bottom + top
        } else if line.starts(with: "deal with increment") {
            let increment = Int(components[3])!
            var newDeck: [Int] = .init(repeating: 0, count: deckSize)
            var i = 0
            while !deck.isEmpty {
                newDeck[i] = deck.removeFirst()
                i = (i + increment) % deckSize
            }
            deck = newDeck
        } else {
            fatalError()
        }
    }

    return deck
}

let example1 = """
deal with increment 7
deal into new stack
deal into new stack
"""

let example2 = """
cut 6
deal with increment 7
deal into new stack
"""

let example3 = """
deal with increment 7
deal with increment 9
cut -2
"""

let example4 = """
deal into new stack
cut -2
deal with increment 7
cut 8
cut -4
deal with increment 7
cut 3
deal with increment 9
deal with increment 3
cut -1
"""

print("Example 1: \(part1(input: example1, deckSize: 10))")
print("Example 2: \(part1(input: example2, deckSize: 10))")
print("Example 3: \(part1(input: example3, deckSize: 10))")
print("Example 4: \(part1(input: example4, deckSize: 10))")

let input = Advent.contentsOfFile(withName: "input.txt")!
let deck1 = part1(input: input, deckSize: 10007)
let answer1 = deck1.firstIndex(of: 2019)!
print("Part1: \(answer1)")
