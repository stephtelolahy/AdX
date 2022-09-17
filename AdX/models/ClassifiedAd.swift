//
//  ClassifiedAd.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//
import Foundation

struct ClassifiedAd {
    let id: Int
    let title: String
    let category: Category
    let creationDate: Date?
    let desc: String
    let isUrgent: Bool
    let images: ImagesUrl
    let price: Decimal
}

extension ClassifiedAd: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ClassifiedAd, rhs: ClassifiedAd) -> Bool {
        lhs.id == rhs.id
    }
}
