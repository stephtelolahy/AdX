//
//  AdRepositoryTests.swift
//  AdXTests
//
//  Created by TELOLAHY Hugues Stéphano on 23/09/2022.
//
// swiftlint:disable overridden_super_call
// swiftlint:disable line_length

import XCTest
import Combine
@testable import AdX

class AdRepositoryTests: XCTestCase {
    
    private var sut: AdRepository!
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        let client = HTTPClient(session: .mockedResponsesOnly, baseURL: "https://ad.service.com")
        sut = AdRepository(client: client)
    }
    
    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    func test_loadAds_success() throws {
        // Given
        let requestURL = try XCTUnwrap(URL(string: "https://ad.service.com/listing.json"))
        let responseData = try XCTUnwrap(loadStub(named: "listing"))
        let mock = MockedResponse(url: requestURL, result: .success(responseData))
        RequestMocking.add(mock: mock)
        
        // When
        // Assert
        let exp = XCTestExpectation(description: "Completion")
        sut.loadAds()
            .sinkToResult { result in
                switch result {
                case let .success(resultValue):
                    XCTAssertEqual(resultValue.count, 1)
                    let ad = resultValue[0]
                    XCTAssertEqual(ad.id, 1461267313)
                    XCTAssertEqual(ad.title, "Statue homme noir assis en plâtre polychrome")
                    XCTAssertEqual(ad.category.id, 4)
                    XCTAssertEqual(ad.category.name, "")
                    XCTAssertNotNil(ad.creationDate)
                    XCTAssertEqual(ad.desc, "Magnifique Statuette homme noir assis fumant le cigare en terre cuite et plâtre polychrome réalisée à la main.  Poids  1,900 kg en très bon état, aucun éclat  !  Hauteur 18 cm  Largeur : 16 cm Profondeur : 18cm  Création Jacky SAMSON  OPTIMUM  PARIS  Possibilité de remise sur place en gare de Fontainebleau ou Paris gare de Lyon, en espèces (heure et jour du rendez-vous au choix). Envoi possible ! Si cet article est toujours visible sur le site c'est qu'il est encore disponible")
                    XCTAssertFalse(ad.isUrgent)
                    XCTAssertEqual(ad.images.small, "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg")
                    XCTAssertEqual(ad.images.thumb, "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg")
                    XCTAssertEqual(ad.price, 140.00)
                    
                case let .failure(error):
                    XCTFail("Unexpected error: \(error)")
                }
                exp.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
}
