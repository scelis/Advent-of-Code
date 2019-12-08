import AdventKit
import Foundation

let ImageWidth = 25
let ImageHeight = 6

func part1(imageData: String) -> Int {
    var layer = 0
    var x = 0
    var y = 0
    var layerData: [Character: Int] = [:]

    var layerDatas: [[Character: Int]] = []
    for character in imageData {
        layerData[character] = (layerData[character] ?? 0) + 1

        x = (x + 1) % ImageWidth
        if x == 0 {
            y = (y + 1) % ImageHeight
            if y == 0 {
                layer += 1
                layerDatas.append(layerData)
                layerData = [:]
            }
        }
    }

    let minData = layerDatas.min { a, b -> Bool in
        return (a[Character("0")] ?? 0) < (b[Character("0")] ?? 0)
    }

    return (minData![Character("1")] ?? 0) * (minData![Character("2")] ?? 0)
}

func part2(imageData: String) -> [[String]] {
    var x = 0
    var y = 0
    var result: [[String]] = .init(repeating: .init(repeating: "2", count: ImageWidth), count: ImageHeight)

    for character in imageData {
        switch character {
        case "0", "1":
            if result[y][x] == "2" {
                result[y][x] = String(character)
            }
        case "2":
            break
        default:
            fatalError()
        }

        x = (x + 1) % ImageWidth
        if x == 0 {
            y = (y + 1) % ImageHeight
        }
    }

    return result
}

let input = Advent.contentsOfFile(withName: "input.txt")!
let answer1 = part1(imageData: input)
print("Part 1: \(answer1)")

print("Part 2:")
let answer2 = part2(imageData: input)
for line in answer2 {
    print(line.joined())
}
