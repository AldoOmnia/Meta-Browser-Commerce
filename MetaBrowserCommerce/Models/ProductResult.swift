//
//  ProductResult.swift
//  Meta Browser Commerce
//

import Foundation

struct ProductResult: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let price: Decimal
    let source: String
    let imageURL: String?
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: ProductResult
    var quantity: Int
}
