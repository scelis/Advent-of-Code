//
//  main.swift
//  Day07
//
//  Created by Sebastian Celis on 11/11/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import AdventKit
import Foundation

let input = Advent.contentsOfFile(withName: "input.txt")!

var allSteps: Set<String> = []
var forwards: [String: Set<String>] = [:]  // A must be finished before starting [B, C]
var backwards: [String: Set<String>] = [:] // A requires [B, C] to finish first

try! input.enumerateMatches(
    withPattern: "^Step ([A-Z]) must be finished before step ([A-Z]) can begin.$",
    patternOptions: [.anchorsMatchLines],
    using: { match, groups in
        let a = groups[0]!
        let b = groups[1]!
        allSteps.insert(a)
        allSteps.insert(b)

        var forward = forwards[a] ?? []
        forward.insert(b)
        forwards[a] = forward

        var backward = backwards[b] ?? []
        backward.insert(a)
        backwards[b] = backward
    }
)

func part1() {
    var steps: [String] = []
    var stepsTaken: Set<String> = []
    var stepsToTake = allSteps
    while !stepsToTake.isEmpty {
        var possibleSteps: Set<String> = []
        for step in stepsToTake {
            if (backwards[step] ?? []).isSubset(of: stepsTaken) {
                possibleSteps.insert(step)
            }
        }

        let stepToTake = possibleSteps.min(by: <)!
        steps.append(stepToTake)
        stepsToTake.remove(stepToTake)
        stepsTaken.insert(stepToTake)
    }
    print("Part 1: \(steps.joined(separator: ""))")
}

class Worker {
    var currentStep: String?
    var processingTimeLeft = 0
}

func part2() {
    var workers: [Worker] = []
    for _ in 0..<5 {
        workers.append(Worker())
    }

    var stepsTaken: Set<String> = []
    var stepsToTake = allSteps
    var second = 0
    while true {
        // Check for finished work items
        for worker in workers {
            if let currentStep = worker.currentStep {
                worker.processingTimeLeft -= 1
                if worker.processingTimeLeft == 0 {
                    stepsTaken.insert(currentStep)
                    worker.currentStep = nil
                }
            }
        }

        // Determine unblocked work items
        var possibleSteps: [String] = []
        for step in stepsToTake {
            if (backwards[step] ?? []).isSubset(of: stepsTaken) {
                possibleSteps.append(step)
            }
        }
        possibleSteps.sort()

        // Assign new work items
        for worker in workers {
            if
                worker.currentStep == nil,
                !possibleSteps.isEmpty
            {
                let stepToTake = possibleSteps.removeFirst()
                worker.currentStep = stepToTake
                worker.processingTimeLeft = Int(60 + Character(stepToTake).asciiValue! - 64)
                stepsToTake.remove(stepToTake)
            }
        }

        // Check stopping condition
        if workers.filter({ $0.currentStep == nil }).count == 5 {
            break
        }

        second += 1
    }

    print("Part 2: \(second)") // < 1227
}

part1()
part2()
