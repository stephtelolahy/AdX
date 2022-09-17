//
//  CategoryFilter.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 18/09/2022.
//

struct CategoryFilter {
    let id: Int
    let name: String
    let count: Int
    let isSelected: Bool
}

extension CategoryFilter: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CategoryFilter, rhs: CategoryFilter) -> Bool {
        lhs.id == rhs.id && lhs.isSelected == rhs.isSelected
    }
}
