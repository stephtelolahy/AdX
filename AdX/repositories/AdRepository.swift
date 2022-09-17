//
//  AdRepository.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Combine

protocol AdRepositoryProtocol {
    func loadAds() -> AnyPublisher<[ClassifiedAd], Error>
    func loadCategories() -> AnyPublisher<[Category], Error>
}

struct AdRepository: AdRepositoryProtocol {
    let client: HTTPClient
    
    func loadAds() -> AnyPublisher<[ClassifiedAd], Error> {
        client.request([ClassifiedAdDto].self, path: "/listing.json")
            .map { $0.compactMap { AdMapper.map(dto: $0) } }
            .eraseToAnyPublisher()
    }
    
    func loadCategories() -> AnyPublisher<[Category], Error> {
        client.request([CategoryDto].self, path: "/categories.json")
            .map { $0.compactMap { CategoryMapper.map(dto: $0) } }
            .eraseToAnyPublisher()
    }
}
