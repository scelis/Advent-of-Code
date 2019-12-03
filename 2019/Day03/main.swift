import AdventKit
import Foundation

struct SimpleVector {
    var direction: Direction
    var length: Int

    init(rawValue: String) {
        var rawValue = rawValue
        self.direction = Direction(rawValue: String(rawValue.removeFirst()))!
        self.length = Int(rawValue)!
    }
}

func parseVectors(line: String) -> [SimpleVector] {
    return line.components(separatedBy: ",").compactMap({ SimpleVector(rawValue: $0) })
}

func allCoordinates(vectors: [SimpleVector]) -> [Coordinate: Int] {
    var coordinates = [Coordinate: Int]()

    var steps = 0
    var current = Coordinate(x: 0, y: 0)
    for vector in vectors {
        for _ in 0..<vector.length {
            let next = Coordinate(x: current.x + vector.direction.dx, y: current.y + vector.direction.dy)
            steps += 1
            coordinates[next] = coordinates[next] ?? steps
            current = next
        }
    }

    return coordinates
}

func findIntersection(input: String, closest: Bool = true) -> Int {
    var vectors: [[SimpleVector]] = []
    input.enumerateLines { line in
        vectors.append(parseVectors(line: line))
    }

    let origin = Coordinate(x: 0, y: 0)
    let vA = vectors[0]
    let vB = vectors[1]
    let coordinatesA = allCoordinates(vectors: vA)
    let coordinatesB = allCoordinates(vectors: vB)

    var intersections = Set(coordinatesA.keys).intersection(coordinatesB.keys)
    intersections.remove(origin)

    return intersections.reduce(Int.max) { result, coordinate -> Int in
        if closest {
            return min(result, coordinate.manhattanDistance(from: origin))
        } else {
            return min(result, coordinatesA[coordinate]! + coordinatesB[coordinate]!)
        }
    }
}

let example1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
let example2 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
let input = Advent.contentsOfFile(withName: "input.txt")!

print("Example 1a: \(findIntersection(input: example1))")
print("Example 2a: \(findIntersection(input: example2))")
print("Part 1: \(findIntersection(input: input))")

print("Example 1b: \(findIntersection(input: example1, closest: false))")
print("Example 2b: \(findIntersection(input: example2, closest: false))")
print("Part 1: \(findIntersection(input: input, closest: false))")
