import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct PapancaZone: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case essays
        case glossary
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://papanca.zone")!
    var name = "Papanca.Zone"
    var description = "A proliferation of meditation and Dharma stuff"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the theme:
try PapancaZone().publish(withTheme: .papancaZone)
