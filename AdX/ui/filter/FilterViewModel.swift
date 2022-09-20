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
    
    var resultsCountPublisher: AnyPublisher<Int, Never> {
        $filters
            .map { $0.resultsCount }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Properties
    
    private let navigator: NavigatorProtocol
    private var completion: (([CategoryFilter]) -> Void)?
    
    // MARK: - Init
    
    init(navigator: NavigatorProtocol) {
        self.navigator = navigator
    }
    
    // MARK: - Arguments
    
    func initialize(with filters: [CategoryFilter], completion: (([CategoryFilter]) -> Void)?) {
        self.filters = filters
        self.completion = completion
    }
    
    // MARK: - Events
    
    func onSelectItem(at index: Int) {
        filters[index] = filters[index].toggled()
    }
    
    func onValidate() {
        completion?(filters)
        navigator.dismiss()
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

private extension Array where Element == CategoryFilter {
    
    var resultsCount: Int {
        var active = self.filter { $0.isSelected }
        if active.isEmpty {
            active = self
        }
        
        return active.reduce(0) { result, filter in
            result + filter.count
        }
    }
}
