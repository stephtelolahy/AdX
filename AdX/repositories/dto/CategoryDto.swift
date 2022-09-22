//
//  CategoryDto.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 17/09/2022.
//

import Foundation

/// Data structure representing API response
///
struct CategoryDto: Decodable {
    let id: Int?
    let name: String?
}
