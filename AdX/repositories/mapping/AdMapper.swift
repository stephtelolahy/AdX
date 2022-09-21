//
//  AdMapper.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

/// Safely mapping DTO objects to application models
///
import Foundation

enum AdMapper {
    
    static func map(dto: ClassifiedAdDto) -> ClassifiedAd? {
        guard let id = dto.id,
              let title = dto.title,
              let catId = dto.category_id,
              let creationDate = dto.creation_date,
              let desc = dto.description,
              let isUrgent = dto.is_urgent,
              let images = dto.images_url,
              let price = dto.price else {
            return nil
        }
        
        return ClassifiedAd(id: id,
                            title: title,
                            category: Category(id: catId, name: ""),
                            creationDate: DateUtils.date(from: creationDate, with: "yyyy-MM-dd'T'HH:mm:ssZ"),
                            desc: desc,
                            isUrgent: isUrgent,
                            images: map(dto: images),
                            price: price)
    }
    
    private static func map(dto: ClassifiedAdDto.ImagesUrlDto) -> ImagesUrl {
        ImagesUrl(small: dto.small ?? "",
                  thumb: dto.thumb ?? "")
    }
}
