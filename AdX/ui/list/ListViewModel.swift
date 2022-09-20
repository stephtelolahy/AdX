//
//  ListViewModel.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Combine
import Foundation

class ListViewModel {
    
    // MARK: - State
    
    @Published private(set) var state: Loadable<[ClassifiedAd]> = .loading
    @Published private(set) var filters: [CategoryFilter] = []
    
    private var allAds: [ClassifiedAd] = []
    
    var filtersCountPublisher: AnyPublisher<Int, Never> {
        $filters
            .map { $0.activeCount }
            .eraseToAnyPublisher()
    }
    
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
        Publishers.Zip(repository.loadAds(), repository.loadCategories())
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                    
                case let .failure(error):
                    self?.state = .failed(error)
                }
            }, receiveValue: { [weak self] value in
                self?.process(ads: value.0, categories: value.1)
            })
            .store(in: &disposables)
    }
    
    func onSelectItem(at index: Int) {
        guard case let .loaded(items) = state else {
            return
        }
        
        navigator.toDetails(items[index])
    }
    
    func onFilter() {
        navigator.toFilter(filters) { [weak self] result in
            self?.processFilter(filters: result)
        }
    }
}

private extension ListViewModel {
    
    func process(ads: [ClassifiedAd], categories: [Category]) {
        let fullAds: [ClassifiedAd] = ads.compactMap { ad in
            guard let category = categories.first(where: { $0.id == ad.category.id }) else {
                return nil
            }
            
            return ad.copy(category: category)
            
        }
        self.state = .loaded(fullAds)
        
        self.filters = categories.map { category in CategoryFilter(id: category.id,
                                                                   name: category.name,
                                                                   count: ads.filter { $0.category.id == category.id }.count,
                                                                   isSelected: false)
        }
        
        self.allAds = fullAds
    }
    
    func processFilter(filters: [CategoryFilter]) {
        self.filters = filters
        let active = filters.filter { $0.isSelected }.map { $0.id }
        guard !active.isEmpty else {
            self.state = .loaded(allAds)
            return
        }
        
        let filteredAds = allAds.filter { active.contains($0.category.id) }
        self.state = .loaded(filteredAds)
    }
}

private extension ClassifiedAd {
    
    func copy(category: Category) -> ClassifiedAd {
        ClassifiedAd(id: id,
                     title: title,
                     category: category,
                     creationDate: creationDate,
                     desc: desc,
                     isUrgent: isUrgent,
                     images: images,
                     price: price)
    }
}

private extension Array where Element == CategoryFilter {
    
    var activeCount: Int {
        filter { $0.isSelected }.count
    }
}
