//
//  AdListViewModel.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Combine
import Foundation

class AdListViewModel {
    
    // MARK: - States
    
    @Published private(set) var ads: [ClassifiedAd] = []
    
    // MARK: - Private properties
    
    private var disposables = Set<AnyCancellable>()
    private let repository: AdRepositoryProtocol
    
    // MARK: - Init
    
    init(repository: AdRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Events
    
    func onLoad() {
        repository.loadAds()
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    break // TODO: handle error
                    
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] ads in
                guard let self = self else {
                    return
                }
                
                self.ads = ads
            })
            .store(in: &disposables)
    }
}
