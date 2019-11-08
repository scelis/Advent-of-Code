//
//  AppDelegate.swift
//  Day04
//
//  Created by Sebastian Celis on 11/8/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import AdventKit
import Foundation

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let comp1 = [lhs.year!, lhs.month!, lhs.day!, lhs.hour!, lhs.minute!]
        let comp2 = [rhs.year!, rhs.month!, rhs.day!, rhs.hour!, rhs.minute!]

        for (a, b) in zip(comp1, comp2) {
            if a < b {
                return true
            } else if b < a {
                return false
            }
        }

        return false
    }
}

struct DataPoint {
    enum Action {
        case beginsShift(Int)
        case fallsAsleep
        case wakesUp
    }

    var components: DateComponents
    var action: Action
}

class Guard {
    var identifier: Int
    var totalMinutesAsleep = 0
    var minutesSleepingPerMinute: [Int: Int] = [:]

    var sleepiestMinute: Int! {
        return minutesSleepingPerMinute.keys.max { a, b in
            return minutesSleepingPerMinute[a]! < minutesSleepingPerMinute[b]!
        }
    }

    init(identifier: Int) {
        self.identifier = identifier
    }
}

let dateRegex = try! NSRegularExpression(pattern: "\\[([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+)\\]", options: [])
let shiftRegex = try! NSRegularExpression(pattern: "Guard #([0-9]+) begins shift", options: [])

func parse(input: String) throws -> DataPoint {
    var components = DateComponents()
    try input.enumerateMatches(withRegularExpression: dateRegex) { match, groups in
        components.year = Int(groups[0]!)
        components.month = Int(groups[1]!)
        components.day = Int(groups[2]!)
        components.hour = Int(groups[3]!)
        components.minute = Int(groups[4]!)
        return
    }

    var action: DataPoint.Action?
    if input.contains("falls asleep") {
        action = .fallsAsleep
    } else if input.contains("wakes up") {
        action = .wakesUp
    } else {
        try input.enumerateMatches(withRegularExpression: shiftRegex) { match, groups in
            action = .beginsShift(Int(groups[0]!)!)
            return
        }
    }

    return DataPoint(components: components, action: action!)
}

func executeStrategy1(dataPoints: [DataPoint]) -> Int {
    var allGuards: [Int: Guard] = [:]
    var currentGuardIdentifier: Int!
    var beginSleepMinute: Int!

    for dataPoint in dataPoints {
        switch dataPoint.action {
        case .beginsShift(let identifier):
            currentGuardIdentifier = identifier
        case .fallsAsleep:
            beginSleepMinute = dataPoint.components.minute
        case .wakesUp:
            let endSleepMinute: Int! = dataPoint.components.minute

            let theGuard = allGuards[currentGuardIdentifier!] ?? Guard(identifier: currentGuardIdentifier)
            allGuards[currentGuardIdentifier] = theGuard

            for i in beginSleepMinute..<endSleepMinute {
                theGuard.minutesSleepingPerMinute[i] = (theGuard.minutesSleepingPerMinute[i] ?? 0) + 1
                theGuard.totalMinutesAsleep += 1
            }
        }
    }

    let mostAsleep: Guard! = allGuards.values.max { a, b in
        return a.totalMinutesAsleep < b.totalMinutesAsleep
    }

    let minute: Int! = mostAsleep.minutesSleepingPerMinute.keys.max { a, b in
        return mostAsleep.minutesSleepingPerMinute[a]! < mostAsleep.minutesSleepingPerMinute[b]!
    }

    return mostAsleep.identifier * minute
}

func run(dataPoints: [DataPoint]) {
    var allGuards: [Int: Guard] = [:]
    var currentGuardIdentifier: Int!
    var beginSleepMinute: Int!

    for dataPoint in dataPoints {
        switch dataPoint.action {
        case .beginsShift(let identifier):
            currentGuardIdentifier = identifier
        case .fallsAsleep:
            beginSleepMinute = dataPoint.components.minute
        case .wakesUp:
            let endSleepMinute: Int! = dataPoint.components.minute

            let theGuard = allGuards[currentGuardIdentifier!] ?? Guard(identifier: currentGuardIdentifier)
            allGuards[currentGuardIdentifier] = theGuard

            for i in beginSleepMinute..<endSleepMinute {
                theGuard.minutesSleepingPerMinute[i] = (theGuard.minutesSleepingPerMinute[i] ?? 0) + 1
                theGuard.totalMinutesAsleep += 1
            }
        }
    }

    let part1Guard: Guard! = allGuards.values.max { a, b in
        return a.totalMinutesAsleep < b.totalMinutesAsleep
    }
    let part1Minute: Int! = part1Guard.sleepiestMinute
    print("Part 1: \(part1Guard.identifier * part1Minute)")

    var part2Guard: Guard?
    var part2Minute: Int?
    var part2Count: Int?
    for theGuard in allGuards.values {
        if part2Guard != nil {
            let thisMinute = theGuard.sleepiestMinute
            let thisCount = theGuard.minutesSleepingPerMinute[thisMinute!]
            if thisCount! > part2Count! {
                part2Guard = theGuard
                part2Minute = thisMinute
                part2Count = thisCount
            }
        } else {
            part2Guard = theGuard
            part2Minute = theGuard.sleepiestMinute
            part2Count = theGuard.minutesSleepingPerMinute[part2Minute!]
        }
    }
    print("Part 2: \(part2Guard!.identifier * part2Minute!)")
}

let lines = Advent.readLinesOfFile(withName: "input.txt")
var dataPoints = lines.map({ try! parse(input: $0) })
dataPoints.sort(by: { a, b -> Bool in
    return a.components < b.components
})

run(dataPoints: dataPoints)
