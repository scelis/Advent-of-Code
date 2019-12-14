import AdventKit
import Foundation

class Moon {
    var position: Coordinate3D
    var velocity: Velocity3D

    init(position: Coordinate3D, velocity: Velocity3D = .zero) {
        self.position = position
        self.velocity = velocity
    }
}

func part1(a: Coordinate3D, b: Coordinate3D, c: Coordinate3D, d: Coordinate3D, steps: Int) -> Int {
    var moons: [Moon] = []
    moons.append(Moon(position: a))
    moons.append(Moon(position: b))
    moons.append(Moon(position: c))
    moons.append(Moon(position: d))

    for _ in 0..<steps {
        for i in 0..<moons.count {
            for j in i+1..<moons.count {
                let moon1 = moons[i]
                let moon2 = moons[j]

                if moon1.position.x < moon2.position.x {
                    moon1.velocity.x += 1
                    moon2.velocity.x -= 1
                } else if moon1.position.x > moon2.position.x {
                    moon1.velocity.x -= 1
                    moon2.velocity.x += 1
                }
                if moon1.position.y < moon2.position.y {
                    moon1.velocity.y += 1
                    moon2.velocity.y -= 1
                } else if moon1.position.y > moon2.position.y {
                    moon1.velocity.y -= 1
                    moon2.velocity.y += 1
                }
                if moon1.position.z < moon2.position.z {
                    moon1.velocity.z += 1
                    moon2.velocity.z -= 1
                } else if moon1.position.z > moon2.position.z {
                    moon1.velocity.z -= 1
                    moon2.velocity.z += 1
                }
            }
        }

        for moon in moons {
            moon.position.x += moon.velocity.x
            moon.position.y += moon.velocity.y
            moon.position.z += moon.velocity.z
        }
    }

    var energy = 0
    for moon in moons {
        let potentialEnergy = abs(moon.position.x) + abs(moon.position.y) + abs(moon.position.z)
        let kineticEnergy = abs(moon.velocity.x) + abs(moon.velocity.y) + abs(moon.velocity.z)
        energy = energy + (potentialEnergy * kineticEnergy)
    }

    return energy
}

func part2(a: Coordinate3D, b: Coordinate3D, c: Coordinate3D, d: Coordinate3D) -> Int {
    var moons: [Moon] = []
    moons.append(Moon(position: a))
    moons.append(Moon(position: b))
    moons.append(Moon(position: c))
    moons.append(Moon(position: d))

    var counts: [Int] = []
    outer: for i in 0..<3 {
        var steps = 0
        var seen: Set<[Int]> = []
        while true {
            let state: [Int]
            if i == 0 {
                state = Array(moons.map({ [$0.position.x, $0.velocity.x] }).joined())
            } else if i == 1 {
                state = Array(moons.map({ [$0.position.y, $0.velocity.y] }).joined())
            } else {
                state = Array(moons.map({ [$0.position.z, $0.velocity.z] }).joined())
            }

            if seen.contains(state) {
                counts.append(steps)
                continue outer
            } else {
                seen.insert(state)
            }

            for j in 0..<moons.count {
                for k in j+1..<moons.count {
                    let moon1 = moons[j]
                    let moon2 = moons[k]

                    if i == 0 {
                        if moon1.position.x < moon2.position.x {
                            moon1.velocity.x += 1
                            moon2.velocity.x -= 1
                        } else if moon1.position.x > moon2.position.x {
                            moon1.velocity.x -= 1
                            moon2.velocity.x += 1
                        }
                    } else if i == 1 {
                        if moon1.position.y < moon2.position.y {
                            moon1.velocity.y += 1
                            moon2.velocity.y -= 1
                        } else if moon1.position.y > moon2.position.y {
                            moon1.velocity.y -= 1
                            moon2.velocity.y += 1
                        }
                    } else {
                        if moon1.position.z < moon2.position.z {
                            moon1.velocity.z += 1
                            moon2.velocity.z -= 1
                        } else if moon1.position.z > moon2.position.z {
                            moon1.velocity.z -= 1
                            moon2.velocity.z += 1
                        }
                    }
                }
            }

            for moon in moons {
                if i == 0 {
                    moon.position.x += moon.velocity.x
                } else if i == 1 {
                    moon.position.y += moon.velocity.y
                } else {
                    moon.position.z += moon.velocity.z
                }
            }

            steps += 1
        }
    }

    return counts.leastCommonMultiple
}

func c(_ x: Int, _ y: Int, _ z: Int) -> Coordinate3D { .init(x: x, y: y, z: z) }
NSLog("Example 1: \(part1(a: c(-1, 0, 2), b: c(2, -10, -7), c: c(4, -8, 8), d: c(3, 5, -1), steps: 10))")
NSLog("Part 1: \(part1(a: c(16, -11, 2), b: c(0, -4, 7), c: c(6, 4, -10), d: c(-3, -2, -4), steps: 1000))")
NSLog("Example 2: \(part2(a: c(-1, 0, 2), b: c(2, -10, -7), c: c(4, -8, 8), d: c(3, 5, -1)))")
NSLog("Part 2: \(part2(a: c(16, -11, 2), b: c(0, -4, 7), c: c(6, 4, -10), d: c(-3, -2, -4)))")
