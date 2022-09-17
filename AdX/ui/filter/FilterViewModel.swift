//
//  FilterViewModel.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 17/09/2022.
//

import Combine

class FilterViewModel {
    
    // MARK: - State
    
    @Published private(set) var filters: [CategoryFilter] = []
    
    // MARK: - Properties
    
    private let repository: AdRepositoryProtocol
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(repository: AdRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Events
    
    func onLoad() {
        repository.loadCategories()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] categories in
                guard let self = self else {
                    return
                }
                
                self.filters = categories.map { CategoryFilter(id: $0.id,
                                                               name: $0.name,
                                                               count: 0,
                                                               isSelected: false)
                }
            })
            .store(in: &disposables)
    }
    
    func onSelectItem(at index: Int) {
        filters[index] = filters[index].toggled()
    }
}

private extension CategoryFilter {
    
    func toggled() -> CategoryFilter {
        CategoryFilter(id: id,
                       name: name,
                       count: count,
                       isSelected: !isSelected)
    }
}
