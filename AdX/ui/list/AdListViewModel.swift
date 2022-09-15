//
//  AdListViewModel.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Combine
import Foundation

class AdListViewModel {
    
    // MARK: - State
    
    @Published private(set) var state: Loadable<[ClassifiedAd]> = .loading
    
    // MARK: - Properties
    
    private let repository: AdRepositoryProtocol
    private let navigator: NavigatorProtocol
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(repository: AdRepositoryProtocol, navigator: NavigatorProtocol) {
        self.repository = repository
        self.navigator = navigator
    }
    
    // MARK: - Events
    
    func onLoad() {
        repository.loadAds()
            .sink(receiveCompletion: { [weak self] value in
                switch value {
                case let .failure(error):
                    self?.state = .failed(error)
                    
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] ads in
                guard let self = self else {
                    return
                }
                
                self.state = .loaded(ads)
            })
            .store(in: &disposables)
    }
    
    func onSelectItem(at index: Int) {
        guard case let .loaded(items) = state else {
            return
        }
        
        navigator.toAdDetails(items[index])
    }
}
