//
//  ListViewModelTests.swift
//  AdXTests
//
//  Created by TELOLAHY Hugues Stéphano on 23/09/2022.
//

import XCTest
import Combine

class ListViewModelTests: XCTestCase {

    private var sut: ListViewModel!
    private var mockRepository: MockAdRepository!
    private var mockNavigator: MockNavigator!
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        mockRepository = MockAdRepository()
        mockNavigator = MockNavigator()
        sut = ListViewModel(repository: mockRepository, navigator: mockNavigator)
    }
    
    func test_InitialStateIsLoading() {
        // Given
        // When
        // Assert
        let exp = XCTestExpectation(description: #function)
        sut.$state.sink { value in
            guard case .loading = value else {
                XCTFail("Invalid state")
                return
            }
            
            exp.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 1)
    }
    
    func test_LoadBothAdsAndCategories_OnViewLoaded() {
        // Given
        // Configuring expected actions on repository
        mockRepository.actions = .init(expected: [.loadAds, .loadCategories])
        
        // When
        sut.onLoad()
        
        // Assert
        mockRepository.verify()
    }
    
    func test_EmitAdsWithRelatedCategories() {
        // Given
        mockRepository.adsResponse = .success(ClassifiedAd.mockData())
        mockRepository.categoryResponse = .success(Category.mockData())

        // When
        sut.onLoad()

        // Assert
        
        let exp = XCTestExpectation(description: #function)
        sut.$state.sink { value in
            if case let .loaded(ads) = value {
                XCTAssertEqual(ads.count, 1)
                XCTAssertEqual(ads[0].category.id, 2)
                XCTAssertEqual(ads[0].category.name, "cat2")
                exp.fulfill()
            }
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
}

private extension ClassifiedAd {
    
    static func mockData() -> [ClassifiedAd] {
        [
            ClassifiedAd(id: 1123,
                         title: "ad1",
                         category: Category(id: 2, name: ""),
                         creationDate: nil,
                         desc: "desc",
                         isUrgent: false,
                         images: ImagesUrl(small: "smallUrl", thumb: "thumbUrl"),
                         price: 10)
        ]
    }
}

private extension Category {
    static func mockData() -> [Category] {
        [
            Category(id: 1, name: "cat1"),
            Category(id: 2, name: "cat2")
        ]
    }
}
