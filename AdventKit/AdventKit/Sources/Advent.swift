//
//  AdventKit.swift
//  AdventKit
//
//  Created by Sebastian Celis on 11/8/19.
//  Copyright © 2019 Sebastian Celis. All rights reserved.
//

import Foundation

public enum Advent {
    public static func contentsOfFile(withName name: String) -> String? {
        if
            case let components = name.components(separatedBy: "."),
            components.count == 2,
            let url = Bundle.main.url(forResource: components[0], withExtension: components[1]),
            let input = FileManager.default.contents(atPath: url.path),
            let string = String(data: input, encoding: .utf8)
        {
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return nil
        }
    }

    public static func readLinesOfFile(withName name: String) -> [String] {
        guard let text = contentsOfFile(withName: name) else { return [] }
        let lines = text.components(separatedBy: .newlines)
        return lines.compactMap({ line in
            let line = line.trimmingCharacters(in: .whitespaces)
            return line.isEmpty ? nil : line
        })
    }
}
