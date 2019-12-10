import AdventKit
import Foundation

extension Coordinate {
    func isBetween(a: Coordinate, b: Coordinate) -> Bool {
        let x1 = (a.x <= self.x && self.x <= b.x)
        let x2 = (a.x >= self.x && self.x >= b.x)
        let y1 = (a.y <= self.y && self.y <= b.y)
        let y2 = (a.y >= self.y && self.y >= b.y)
        return (x1 || x2) && (y1 || y2)
    }
}

class Day10 {
    let input: String

    lazy var asteroids: Set<Coordinate> = {
        var asteroids: Set<Coordinate> = []

        let array = input.components(separatedBy: .newlines).map { Array($0) }
        for y in 0..<array.count {
            for x in 0..<array[y].count {
                switch array[y][x] {
                case ".":
                    break
                case "#":
                    asteroids.insert(Coordinate(x: x, y: y))
                default:
                    fatalError()
                }
            }
        }

        return asteroids
    }()

    init(input: String) {
        self.input = input
    }

    func part1() -> (Coordinate, Int) {
        var bestAsteroid: Coordinate?
        var mostDetected = 0

        for candidateStation in asteroids {
            var visibleAsteroids = asteroids
            visibleAsteroids.remove(candidateStation)

            for asteroid1 in asteroids {
                for asteroid2 in asteroids {
                    if
                        asteroid1 != asteroid2,
                        visibleAsteroids.contains(asteroid1),
                        visibleAsteroids.contains(asteroid2),
                        areaOfTriangle(a: candidateStation, b: asteroid1, c: asteroid2) == 0
                    {
                        if asteroid1.isBetween(a: candidateStation, b: asteroid2) {
                            visibleAsteroids.remove(asteroid2)
                        } else if asteroid2.isBetween(a: candidateStation, b: asteroid1) {
                            visibleAsteroids.remove(asteroid1)
                        }
                    }
                }
            }

            if visibleAsteroids.count > mostDetected {
                mostDetected = visibleAsteroids.count
                bestAsteroid = candidateStation
            }
        }

        return (bestAsteroid!, mostDetected)
    }

    func part2(station: Coordinate = Coordinate(x: 22, y: 28), numAsteroids: Int = 200) -> (Coordinate, Int) {
        var asteroids = self.asteroids
        asteroids.remove(station)

        var degreesToCoordinates: [Int: [Coordinate]] = [:]
        for asteroid in asteroids {
            // Get the slope from the station to the asteroid in radians
            let radians = atan2(Double(asteroid.y - station.y), Double(asteroid.x - station.x))

            // Convert to degrees and distill down to the 0..<360 range
            var degrees = rad2deg(radians) + 90
            if degrees < 0 {
                degrees += 360
            }

            // Convert to an Int with 3 digits of decimal precision so that we can turn this
            // into a hash key
            let rounded = Int(round(degrees * 1000))

            if var coordinates = degreesToCoordinates[rounded] {
                coordinates.append(asteroid)
                degreesToCoordinates[rounded] = coordinates
            } else {
                degreesToCoordinates[rounded] = [asteroid]
            }
        }

        let allDegreesSorted = degreesToCoordinates.keys.sorted()
        var lastDestroyed: Coordinate?
        var numDestroyed = 0
        var degreesPointer = 0
        while numDestroyed < numAsteroids {
            var coordinates: [Coordinate] = []
            var degrees = 0

            while coordinates.isEmpty {
                degrees = allDegreesSorted[degreesPointer]
                coordinates = degreesToCoordinates[degrees] ?? []
                degreesPointer = (degreesPointer + 1) % allDegreesSorted.count
            }

            let closestCoordinate = coordinates.min { a, b -> Bool in
                return a.manhattanDistance(from: station) < b.manhattanDistance(from: station)
            }

            lastDestroyed = closestCoordinate
            coordinates = coordinates.filter { $0 != closestCoordinate }
            numDestroyed += 1
        }

        return (lastDestroyed!, lastDestroyed!.x * 100 + lastDestroyed!.y)
    }
}


let example1 = """
.#..#
.....
#####
....#
...##
"""

print("Example 1: \(Day10(input: example1).part1()) == (3, 4) 8")

let example2 = """
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
"""

print("Example 2: \(Day10(input: example2).part1()) == (5, 8) 33")

let example3 = """
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
"""

print("Example 3: \(Day10(input: example3).part1()) == (1, 2) 35")

let example4 = """
.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
"""

print("Example 4: \(Day10(input: example4).part1()) == (6, 3) 41")

let example5 = """
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
"""

print("Example 5: \(Day10(input: example5).part1()) == (11, 13) 210")

let input = Advent.contentsOfFile(withName: "input.txt")!
let day10 = Day10(input: input)
print("Part 1: \(day10.part1())")
print("Part 2: \(day10.part2())")
