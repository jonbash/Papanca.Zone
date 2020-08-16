//
//  File.swift
//  
//
//  Created by Jon Bash on 2020-08-08.
//

import Foundation
import Plot


protocol HTMLClass: RawRepresentable, ExpressibleByStringLiteral where
    RawValue == String,
    StringLiteralType == String
{}


extension HTML {
    indirect enum Class: HTMLClass {
        case siteName
        case content
        case wrapper
        case description
        case itemPage
        case selected

        case tag
        case tagList
        case allTags

        case browseAll
        case itemList

        case other(String)
        case multiple([Self])
        case empty
    }
}

// MARK: - RawRepresentable

extension HTML.Class: RawRepresentable {
    var rawValue: String {
        switch self {
        case .content: return "content"
        case .wrapper: return "wrapper"
        case .description: return "description"
        case .itemPage: return "item-page"
        case .selected: return "selected"
        case .siteName: return "site-name"
        case .tag: return "tag"
        case .tagList: return "tag-list"
        case .allTags: return "all-tags"
        case .browseAll: return "browse-all"
        case .itemList: return "item-list"
        case .other(let str): return str
        case .multiple(let classes):
            return classes.dropFirst().reduce(
                into: classes.first?.rawValue ?? "",
                { out, cls in
                    guard cls != .empty else { return }
                    out += " \(cls.rawValue)"
                }
            )
        case .empty:
            return ""
        }
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "wrapper":
            self = .wrapper
        case "description":
            self = .description
        case "selected":
            self = .selected
        case "site-name":
            self = .siteName
        case "tag-list":
            self = .tagList
        case "item-list":
            self = .itemList
        case "":
            self = .empty
        default:
            self = .other(rawValue)
        }
    }
}


// MARK: - String Literal

extension HTML.Class: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}


// MARK: - Node

extension Node where Context: HTMLContext {
    static func `class`(_ htmlClass: HTML.Class) -> Node {
        .class(htmlClass.rawValue)
    }
}
