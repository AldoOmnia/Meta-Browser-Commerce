//
//  SearchService.swift
//  Meta Browser Commerce
//
//  Demo search: multi-platform results for E2E flow testing.
//  Browser-use integration: Connect Amazon in Settings, then run a voice search
//  (e.g. "Find running shoes") to open Nike/Amazon URLs. For full automation,
//  wire up Omnia MCP + browser-use backend to perform add-to-cart etc.
//

import Foundation

enum SearchService {
    /// Extract product search term from voice query
    static func extractSearchTerm(from query: String) -> String {
        var clean = query
        for phrase in ["help me", "find", "search for", "compare", "add", "to cart", "under $", "cheaper alternative", "search what I see", "what I'm looking at", "options for", "that fits my", "fits my"] {
            clean = clean.replacingOccurrences(of: phrase, with: " ", options: .caseInsensitive)
        }
        return clean.trimmingCharacters(in: .whitespaces)
    }

    /// Multi-platform search for E2E: returns results from Nike + Amazon when connected
    static func runSearch(query: String) -> (URL, [ProductResult]) {
        let searchTerm = extractSearchTerm(from: query)
        let term = searchTerm.isEmpty ? "running shoes" : searchTerm
        let encoded = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? term

        let isFurnitureQuery = query.lowercased().contains("sofa") || query.lowercased().contains("living room") || query.lowercased().contains("furniture")

        if isFurnitureQuery {
            let url = URL(string: "https://www.wayfair.com/furniture/sb0/sofas-c413892.html")!
            var results: [ProductResult] = [
                ProductResult(title: "Urban Sofa", description: "Fits spaces 8'–10'", price: 599, source: "Wayfair", imageURL: nil),
                ProductResult(title: "Compact Loveseat", description: "Room-friendly 52\" width", price: 449, source: "Wayfair", imageURL: nil),
                ProductResult(title: "Sectional 3-Piece", description: "Modular for any layout", price: 899, source: "Wayfair", imageURL: nil),
            ]
            if PlatformConnectionStore.isConnected(platformId: "amazon") {
                results.append(contentsOf: [
                    ProductResult(title: "Modern Accent Sofa", description: "Amazon • Free delivery", price: 529, source: "Amazon", imageURL: nil),
                    ProductResult(title: "Apartment Sofa", description: "Small space design", price: 379, source: "Amazon", imageURL: nil),
                ])
            }
            return (url, results)
        }

        let url = URL(string: "https://www.nike.com/w?q=\(encoded)")!
        var results: [ProductResult] = [
            ProductResult(title: "Nike Revolution 7", description: "Men's running shoes", price: 69.97, source: "Nike", imageURL: nil),
            ProductResult(title: "Nike Air Zoom Pegasus", description: "Lightweight cushioning", price: 79.99, source: "Nike", imageURL: nil),
            ProductResult(title: "Nike Downshifter 13", description: "Everyday runner", price: 64.99, source: "Nike", imageURL: nil),
        ]
        if PlatformConnectionStore.isConnected(platformId: "amazon") {
            results.append(contentsOf: [
                ProductResult(title: "Adidas Runfalcon 3", description: "Amazon • Prime", price: 62.99, source: "Amazon", imageURL: nil),
                ProductResult(title: "New Balance 540v5", description: "Amazon • Free shipping", price: 74.99, source: "Amazon", imageURL: nil),
            ])
        }
        return (url, results)
    }

    /// Dining & delivery: La Colombe, Starbucks, Uber Eats
    static func runDiningOrder(venue: String) -> (URL, [ProductResult]) {
        let (url, items): (URL, [ProductResult])
        switch venue.lowercased() {
        case "la colombe", "lacolombe":
            url = URL(string: "https://www.lacolombe.com/pages/store-locator")!
            items = [
                ProductResult(title: "Large Oat Latte", description: "Pickup at nearest store", price: 6.50, source: "La Colombe", imageURL: nil),
                ProductResult(title: "Cortado", description: "Pickup at nearest store", price: 4.75, source: "La Colombe", imageURL: nil),
            ]
        case "starbucks":
            url = URL(string: "https://www.starbucks.com/store-locator")!
            items = [
                ProductResult(title: "Venti Latte", description: "Pickup at nearest store", price: 5.95, source: "Starbucks", imageURL: nil),
                ProductResult(title: "Cold Brew", description: "Pickup at nearest store", price: 4.75, source: "Starbucks", imageURL: nil),
            ]
        case "uber eats", "ubereats":
            url = URL(string: "https://www.ubereats.com")!
            items = [
                ProductResult(title: "Restaurant delivery", description: "Order from local restaurants", price: 0, source: "Uber Eats", imageURL: nil),
                ProductResult(title: "Groceries", description: "Same-day grocery delivery", price: 0, source: "Uber Eats", imageURL: nil),
            ]
        default:
            url = URL(string: "https://www.lacolombe.com/pages/store-locator")!
            items = [
                ProductResult(title: "Large Oat Latte", description: "Pickup at nearest store", price: 6.50, source: venue, imageURL: nil),
                ProductResult(title: "Cortado", description: "Pickup at nearest store", price: 4.75, source: venue, imageURL: nil),
            ]
        }
        return (url, items)
    }
}
