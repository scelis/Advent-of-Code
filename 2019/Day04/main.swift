import AdventKit
import Foundation

func isValidPassword(number: Int, strict: Bool) -> Bool {
    var previous: Int?
    var foundDouble = false
    var foundStrictDouble = false

    let digits = number.digits
    for (index, digit) in digits.enumerated() {
        var isIncreasing = false

        if let previous = previous {
            if previous > digit {
                return false
            } else if previous == digit {
                foundDouble = true
            } else {
                isIncreasing = true
            }
        } else {
            isIncreasing = true
        }

        if
            strict,
            isIncreasing,
            foundStrictDouble == false,
            index < digits.count - 1,
            digits[index + 1] == digit,
            (index >= digits.count - 2 || digits[index + 2] != digit)
        {
            foundStrictDouble = true
        }

        previous = digit
    }

    return strict ? foundStrictDouble : foundDouble
}

func numberOfPasswords(in range: ClosedRange<Int>, strict: Bool) -> Int {
    var numberOfPasswords = 0

    for i in range {
        if isValidPassword(number: i, strict: strict) {
            numberOfPasswords += 1
        }
    }

    return numberOfPasswords
}

let range = 146810...612564
print("Part 1: \(numberOfPasswords(in: range, strict: false))")
print("Part 2: \(numberOfPasswords(in: range, strict: true))")
