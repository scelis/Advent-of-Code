//
//  IntcodeComputer.swift
//  AdventKit
//
//  Created by Sebastian Celis on 12/5/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public class IntcodeComputer {

    public enum Opcode: Int {
        case add = 1
        case multiply = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case halt = 99

        public var parameterCount: Int {
            switch self {
            case .add: return 3
            case .multiply: return 3
            case .input: return 1
            case .output: return 1
            case .jumpIfTrue: return 2
            case .jumpIfFalse: return 2
            case .lessThan: return 3
            case .equals: return 3
            case .halt: return 0
            }
        }
    }

    public enum ParameterMode: Int {
        case position = 0
        case immediate = 1
    }

    public var memory: [Int]

    public init(memory: [Int]) {
        self.memory = memory
    }

    public func valueForParameter(_ i: Int, offset: Int) -> Int {
        var remainder = memory[i] / 100
        for _ in 0..<(offset - 1) {
            remainder = remainder / 10
        }

        let mode = ParameterMode(rawValue: remainder % 10)!
        switch mode {
        case .position:
            return memory[memory[i + offset]]
        case .immediate:
            return memory[i + offset]
        }
    }

    public func run(input: Int = 0) -> [Int] {
        var running = true
        var i = 0
        var output: [Int] = []

        while running {
            let opcode = Opcode(rawValue: memory[i] % 100)!

            var jumped = false
            switch opcode {
            case .halt:
                running = false
            case .add, .multiply:
                let a = valueForParameter(i, offset: 1)
                let b = valueForParameter(i, offset: 2)
                let f: (Int, Int) -> Int = (opcode == .add) ? (+) : (*)
                memory[memory[i + 3]] = f(a, b)
            case .input:
                memory[memory[i + 1]] = input
            case .output:
                let value = valueForParameter(i, offset: 1)
                output.append(value)
            case .jumpIfTrue, .jumpIfFalse:
                let a = valueForParameter(i, offset: 1)
                if (opcode == .jumpIfTrue && a != 0) || (opcode == .jumpIfFalse && a == 0) {
                    i = valueForParameter(i, offset: 2)
                    jumped = true
                }
            case .lessThan, .equals:
                let a = valueForParameter(i, offset: 1)
                let b = valueForParameter(i, offset: 2)
                if (opcode == .lessThan && a < b) || (opcode == .equals && a == b) {
                    memory[memory[i + 3]] = 1
                } else {
                    memory[memory[i + 3]] = 0
                }
            }

            if !jumped {
                i += opcode.parameterCount + 1
            }
        }

        return output
    }
}
