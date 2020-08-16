//
//  File.swift
//  
//
//  Created by Jon Bash on 2020-08-08.
//

import Publish
import Plot


typealias BodyContent = [Node<HTML.BodyContext>]


extension Theme {
    static var papancaZone: Self {
        Theme(
            htmlFactory: PapancaZoneHTMLFactory(),
            resourcePaths: ["Resources/PapancaZone/styles.css"]
        )
    }
}


// MARK: - HTML Factory

struct PapancaZoneHTMLFactory<Site: Website>: HTMLFactory {
    typealias SectionGenerator = (Section<Site>) -> BodyContent?

    private var sectionGenerator: SectionGenerator

    init(sectionGenerator: @escaping SectionGenerator = { _ in nil }) {
        self.sectionGenerator = sectionGenerator
    }

    func makeIndexHTML(
        for index: Index,
        context: PublishingContext<Site>)
    throws -> HTML {
        html(for: index, context: context, selectedSection: nil, content: [
            .h1(.text(index.title)),
            .p(
                .class(.description),
                .text(context.site.description)
            ),
            .h2("Latest content"),
            .itemList(
                for: context.allItems(
                    sortedBy: \.date,
                    order: .descending
                ),
                on: context.site
            )
        ])
    }

    func makeSectionHTML(
        for section: Section<Site>,
        context: PublishingContext<Site>)
    throws -> HTML {
        html(
            for: section,
            context: context,
            selectedSection: section.id,
            content: {
                sectionGenerator(section) ?? [
                    .h1(.text(section.title)),
                    .itemList(for: section.items, on: context.site)
                ]
            }()
        )
    }

    func makeItemHTML(
        for item: Item<Site>,
        context: PublishingContext<Site>)
    throws -> HTML {
        html(
            for: item,
            context: context,
            selectedSection: item.sectionID,
            content: [
                .article(
                    .div(
                        .class(.content),
                        .contentBody(item.body)
                    ),
                    .span("Tagged with: "),
                    .tagList(for: item, on: context.site)
                )
            ],
            bodyClass: .itemPage)
    }

    func makePageHTML(
        for page: Page,
        context: PublishingContext<Site>)
    throws -> HTML {
        html(for: page, context: context, selectedSection: nil, content: [
            .contentBody(page.body)
        ])
    }

    func makeTagListHTML(
        for page: TagListPage,
        context: PublishingContext<Site>)
    throws -> HTML? {
        html(for: page, context: context, selectedSection: nil, content: [
            .h1("Browse all tags"),
            .ul(
                .class(.allTags),
                .forEach(page.tags.sorted()) { tag in
                    .li(
                        .class(.tag),
                        .a(
                            .href(context.site.path(for: tag)),
                            .text(tag.string)
                        )
                    )
                }
            )
        ])
    }

    func makeTagDetailsHTML(
        for page: TagDetailsPage,
        context: PublishingContext<Site>)
    throws -> HTML? {
        html(for: page, context: context, selectedSection: nil, content: [
            .h1("Tagged with ", .span(.class(.tag), .text(page.tag.string))),
            .a(
                .class(.browseAll),
                .text("Browse all tags"),
                .href(context.site.tagListPath)
            ),
            .itemList(
                for: context.items(
                    taggedWith: page.tag,
                    sortedBy: \.date,
                    order: .descending
                ),
                on: context.site
            )
        ])
    }
}


// MARK: Helpers

extension PapancaZoneHTMLFactory {
    private func html<Site: Website>(
        for location: Location,
        context: PublishingContext<Site>,
        selectedSection: Site.SectionID?,
        content: BodyContent,
        bodyClass: HTML.Class? = nil)
    -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: location, on: context.site),
            .standardBody(
                for: context,
                selectedSection: selectedSection,
                content: content,
                bodyClass: bodyClass)
        )
    }
}


// MARK: - Document Nodes

extension Node where Context == HTML.DocumentContext {
    static func standardBody<Site: Website>(
        for context: PublishingContext<Site>,
        selectedSection: Site.SectionID?,
        content: BodyContent,
        bodyClass: HTML.Class? = nil)
    -> Node {
        .body(header: .header(for: context, selectedSection: selectedSection),
              content: content,
              footer: .footer(),
              bodyClass: bodyClass)
    }

    static func body(
        header: BodyContent.Element,
        content: BodyContent,
        footer: BodyContent.Element,
        bodyClass: HTML.Class? = nil)
    -> Node {
        body(
            .unwrap(bodyClass) { .class($0) },
            header,
            .wrapper(content),
            footer
        )
    }

    static func body(_ content: BodyContent) -> Node {
        .element(named: "body", nodes: content)
    }
}

// MARK: - Body Nodes

extension Node where Context == HTML.BodyContext {
    static func header<Site: Website>(
        for context: PublishingContext<Site>,
        selectedSection: Site.SectionID?
    ) -> Node {
        let sectionIDs = Site.SectionID.allCases

        return .header(
            .wrapper(
                .a(.class(.siteName), .href("/"), .text(context.site.name)),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? .selected : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class(.itemList),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class(.tagList), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    private func footer() -> BodyContent.Element {
        .footer(
            .p(
                .text("Made with love by Jon Bash using Swift & "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .p(.a(
                .text("RSS feed"),
                .href("/feed.rss")
            ))
        )
    }

    static func wrapper(_ nodes: [Node]) -> Node {
        .div(.class(.wrapper), .group(nodes))
    }

    static func wrapper(_ nodes: Node...) -> Node {
        wrapper(nodes)
    }
}
