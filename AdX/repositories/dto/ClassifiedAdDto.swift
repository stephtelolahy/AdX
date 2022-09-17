//
//  ClassifiedAdDto.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//
// swiftlint:disable identifier_name

import Foundation

/// Data structure representing API response
///
struct ClassifiedAdDto: Decodable {
    let id: Int?
    let title: String?
    let category_id: Int?
    let creation_date: String?
    let description: String?
    let is_urgent: Bool?
    let images_url: ImagesUrlDto?
    let price: Decimal?
    let siret: String?
}

extension ClassifiedAdDto {
    
    struct ImagesUrlDto: Decodable {
        let small: String?
        let thumb: String?
    }
}
