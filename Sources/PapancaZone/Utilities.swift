//
//  File.swift
//  
//
//  Created by Jon Bash on 2020-08-07.
//

import Foundation
import Ink
import Plot


func += (lhs: inout String, rhs: Character) {
    lhs = "\(lhs)\(rhs)"
}

func * (lhs: Character, rhs: Int) -> String {
    precondition(rhs >= 0, "Character repetition count must be greater than 0")

    var output = ""
    for _ in 0..<rhs {
        output += lhs
    }

    return output
}


extension String {
    static let defaultMarkdownParser = MarkdownParser()

    func parseToMarkdown(
        with parser: MarkdownParser = Self.defaultMarkdownParser
    ) -> Markdown {
        parser.parse(self)
    }
}


func + <Element>(lhs: Array<Element>, rhs: Element) -> Array<Element> {
    var out = lhs
    out.append(rhs)
    return out
}


func + <Element>(lhs: Element, rhs: Array<Element>) -> Array<Element> {
    var out = [lhs]
    out.append(contentsOf: rhs)
    return out
}


func += <T>(lhs: inout Array<T>, rhs: T) {
    lhs.append(rhs)
}
