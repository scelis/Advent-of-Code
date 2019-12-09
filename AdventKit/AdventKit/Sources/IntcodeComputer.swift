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
        case relativeBaseOffset = 9
        case halt = 99

        public var parameterCount: Int {
            switch self {
            case .halt: return 0
            case .input, .output, .relativeBaseOffset: return 1
            case .jumpIfTrue, .jumpIfFalse: return 2
            case .add, .multiply, .lessThan, .equals: return 3
            }
        }
    }

    public enum ParameterMode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
    }

    public enum State {
        case none
        case running
        case awaitingInput
        case halted
    }

    private(set) public var state = State.none
    public var outputBuffer: [Int] = []

    private var memory: [Int]
    private var additionalMemory: [Int: Int] = [:]
    private var inputBuffer: [Int] = []
    private var i = 0
    private var relativeBase = 0

    // Read & write memory
    public subscript(key: Int) -> Int {
        get {
            return (key < memory.count) ? memory[key] : additionalMemory[key] ?? 0
        }
        set {
            if key < memory.count {
                memory[key] = newValue
            } else {
                additionalMemory[key] = newValue
            }
        }
    }

    public init(memory: [Int]) {
        self.memory = memory
    }

    public func run(input: [Int] = []) {
        state = .running
        inputBuffer.append(contentsOf: input)

        while state == .running {
            let opcode = Opcode(rawValue: self[i] % 100)!

            var jumped = false
            switch opcode {
            case .halt:
                state = .halted
            case .add, .multiply:
                let a = readParameter(i, offset: 1)
                let b = readParameter(i, offset: 2)
                let f: (Int, Int) -> Int = (opcode == .add) ? (+) : (*)
                writeParameter(i, offset: 3, value: f(a, b))
            case .input:
                if inputBuffer.count > 0 {
                    writeParameter(i, offset: 1, value: inputBuffer.removeFirst())
                } else {
                    state = .awaitingInput
                }
            case .output:
                let a = readParameter(i, offset: 1)
                outputBuffer.append(a)
            case .jumpIfTrue, .jumpIfFalse:
                let a = readParameter(i, offset: 1)
                if (opcode == .jumpIfTrue && a != 0) || (opcode == .jumpIfFalse && a == 0) {
                    i = readParameter(i, offset: 2)
                    jumped = true
                }
            case .lessThan, .equals:
                let a = readParameter(i, offset: 1)
                let b = readParameter(i, offset: 2)
                if (opcode == .lessThan && a < b) || (opcode == .equals && a == b) {
                    writeParameter(i, offset: 3, value: 1)
                } else {
                    writeParameter(i, offset: 3, value: 0)
                }
            case .relativeBaseOffset:
                let a = readParameter(i, offset: 1)
                relativeBase += a
            }

            if !jumped && state != .awaitingInput {
                i += opcode.parameterCount + 1
            }
        }
    }

    public func readInt() -> Int? {
        guard !outputBuffer.isEmpty else { return nil }
        return outputBuffer.removeFirst()
    }

    // MARK: - Private

    private func modeForParameter(_ i: Int, offset: Int) -> ParameterMode {
        var remainder = self[i] / 100
        for _ in 0..<(offset - 1) {
            remainder = remainder / 10
        }
        return ParameterMode(rawValue: remainder % 10)!
    }

    private func readParameter(_ i: Int, offset: Int) -> Int {
        let mode = modeForParameter(i, offset: offset)

        switch mode {
        case .position:
            return self[self[i + offset]]
        case .immediate:
            return self[i + offset]
        case .relative:
            return self[self[i + offset] + relativeBase]
        }
    }

    private func writeParameter(_ i: Int, offset: Int, value: Int) {
        let mode = modeForParameter(i, offset: offset)

        switch mode {
        case .position:
            self[self[i + offset]] = value
        case .immediate:
            fatalError()
        case .relative:
            self[self[i + offset] + relativeBase] = value
        }
    }
}
