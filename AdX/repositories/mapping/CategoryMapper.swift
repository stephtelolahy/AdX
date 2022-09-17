//
//  CategoryMapper.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 17/09/2022.
//

enum CategoryMapper {
    
    static func map(dto: CategoryDto) -> Category? {
        guard let id = dto.id,
              let name = dto.name else {
            return nil
        }
        
        return Category(id: id, name: name)
    }
}
