//
//  AdDetailsViewModel.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 15/09/2022.
//

import Combine

class AdDetailsViewModel {
    
    // MARK: - State
    
    @Published private(set) var state: Loadable<ClassifiedAd> = .loading
    
    // MARK: - Initialize
    
    func initialize(with ad: ClassifiedAd) {
        state = .loaded(ad)
    }
}
