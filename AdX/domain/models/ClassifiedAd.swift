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
    let creationDate: Date
    let desc: String
    let isUrgent: Bool
    let images: ImagesUrl
    let price: Decimal
}
