//
//  ImageRepositoryTests.swift
//  AdXTests
//
//  Created by TELOLAHY Hugues Stéphano on 22/09/2022.
//

import XCTest
import Combine
@testable import AdX

final class ImageWebRepositoryTests: XCTestCase {
    
    private var sut: ImageRepository!
    private var subscriptions = Set<AnyCancellable>()
    private lazy var testImage = UIColor.red.image(CGSize(width: 40, height: 40))
    
    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = ImageRepository(session: .mockedResponsesOnly)
    }
    
    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    func test_loadImage_success() throws {
        // Given
        let imageURL = try XCTUnwrap(URL(string: "https://image.service.com/myimage.png"))
        let responseData = try XCTUnwrap(testImage.pngData())
        let mock = MockedResponse(url: imageURL, result: .success(responseData))
        RequestMocking.add(mock: mock)
        let exp = XCTestExpectation(description: "Completion")
        
        // When
        // Assert
        sut.load(imageURL: imageURL)
            .sinkToResult { result in
                switch result {
                case let .success(resultValue):
                    XCTAssertEqual(resultValue.size, self.testImage.size)
                    
                case let .failure(error):
                    XCTFail("Unexpected error: \(error)")
                }
                exp.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_loadImage_failure() throws {
        // Given
        let imageURL = try XCTUnwrap(URL(string: "https://image.service.com/myimage.png"))
        let mocks = [MockedResponse(url: imageURL, result: .failure(APIError.unexpectedResponse))]
        mocks.forEach { RequestMocking.add(mock: $0) }
        let exp = XCTestExpectation(description: "Completion")
        
        // When
        // Assert
        sut.load(imageURL: imageURL)
            .sinkToResult { result in
                result.assertFailure(APIError.unexpectedResponse.localizedDescription)
                exp.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
}
