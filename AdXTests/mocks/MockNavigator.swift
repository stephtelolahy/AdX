//
//  MockNavigator.swift
//  AdXTests
//
//  Created by TELOLAHY Hugues Stéphano on 23/09/2022.
//

final class MockNavigator: Mock, NavigatorProtocol {
    
    enum Action: Equatable {
        case toDetails(ClassifiedAd)
        case toFilter
        case dismiss
    }
    
    var actions = MockActions<Action>(expected: [])
    
    func toDetails(_ ad: ClassifiedAd) {
        register(.toDetails(ad))
    }
    
    func toFilter(_ filters: [CategoryFilter], completion: (([CategoryFilter]) -> Void)?) {
        register(.toFilter)
    }
    
    func dismiss() {
        register(.dismiss)
    }
}
