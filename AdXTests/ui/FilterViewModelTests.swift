//
//  FilterViewModelTests.swift
//  AdXTests
//
//  Created by TELOLAHY Hugues Stéphano on 23/09/2022.
//

import XCTest
import Combine

class FilterViewModelTests: XCTestCase {
    
    private var sut: FilterViewModel!
    private var mockNavigator: MockNavigator!
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        mockNavigator = MockNavigator()
        sut = FilterViewModel(navigator: mockNavigator)
    }
    
    func test_DisplayFiltersPassedAsArgument() {
        // Given
        let filters: [CategoryFilter] = [
            CategoryFilter(id: 1, name: "filter1", count: 0, isSelected: false),
            CategoryFilter(id: 2, name: "filter2", count: 0, isSelected: true)
        ]
        
        // When
        sut.initialize(with: filters, completion: nil)
        
        // Assert
        
        let exp = XCTestExpectation(description: #function)
        sut.$filters.sink { value in
            XCTAssertEqual(filters, value)
            exp.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_Dismiss_IfValidatingFilters() {
        // Given
        // Configuring expected actions on navigator
        mockNavigator.actions = .init(expected: [.dismiss])
        
        // When
        sut.onValidate()
        
        // Assert
        mockNavigator.verify()
    }
    
    func test_ToggleFilter_IfSelecting() {
        // Given
        let filters: [CategoryFilter] = [
            CategoryFilter(id: 1, name: "filter1", count: 0, isSelected: false),
            CategoryFilter(id: 2, name: "filter2", count: 0, isSelected: false)
        ]
        sut.initialize(with: filters, completion: nil)
        
        // When
        sut.onSelectItem(at: 1)
        
        // Assert
        let exp = XCTestExpectation(description: #function)
        sut.$filters.sink { value in
            XCTAssertTrue(value[1].isSelected)
            exp.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
}
