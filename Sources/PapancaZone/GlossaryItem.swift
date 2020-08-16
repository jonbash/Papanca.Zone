//
//  GlossaryItem.swift
//  
//
//  Created by Jon Bash on 2020-08-07.
//

import Foundation
import Publish
import Ink

struct ConceptDefinition {
    let concept: String
    let definition: String

    func toMarkdownString(headingLevel: Int = 2) -> String {
        precondition(headingLevel >= 0, "Markdown heading level must be >= 0")

        return ("#" * headingLevel) + " \(concept)\n\n\(definition)"
    }
}

extension Array where Element == ConceptDefinition {
    func toMarkdown() -> Markdown {
        reduce(into: "") { result, item in
            result += "\n\n\(item.toMarkdownString())"
        }.parseToMarkdown()
    }
}
