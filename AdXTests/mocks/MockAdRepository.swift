//
//  MockAdRepository.swift
//  AdXTests
//
//  Created by TELOLAHY Hugues Stéphano on 23/09/2022.
//
import Foundation
import Combine
@testable import AdX

final class MockAdRepository: Mock, AdRepositoryProtocol {
    enum Action: Equatable {
        case loadAds
        case loadCategories
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var adsResponse: Result<[ClassifiedAd], Error> = .failure(MockError.valueNotSet)
    var categoryResponse: Result<[Category], Error> = .failure(MockError.valueNotSet)
    
    func loadAds() -> AnyPublisher<[ClassifiedAd], Error> {
        register(.loadAds)
        return adsResponse.publish()
    }
    
    func loadCategories() -> AnyPublisher<[Category], Error> {
        register(.loadCategories)
        return categoryResponse.publish()
    }
}
