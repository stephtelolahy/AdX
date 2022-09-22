//
//  RequestMocking.swift
//  AdXTests
//
//  Created by TELOLAHY Hugues Stéphano on 22/09/2022.
//

import Foundation
@testable import AdX

extension URLSession {
    static var mockedResponsesOnly: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [RequestMocking.self, RequestBlocking.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
}

// MARK: - RequestMocking

final class RequestMocking: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        mock(for: request) != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    // swiftlint:disable identifier_name
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        // swiftlint:enable identifier_name
        return false
    }
    
    override func startLoading() {
        if let mock = Self.mock(for: request),
           let url = request.url,
           let response = mock.customResponse ??
            HTTPURLResponse(url: url,
                            statusCode: mock.httpCode,
                            httpVersion: "HTTP/1.1",
                            headerFields: mock.headers) {
            DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                switch mock.result {
                case let .success(data):
                    self.client?.urlProtocol(self, didLoad: data)
                    self.client?.urlProtocolDidFinishLoading(self)
                    
                case let .failure(error):
                    let failure = NSError(domain: NSURLErrorDomain,
                                          code: 1,
                                          userInfo: [NSUnderlyingErrorKey: error])
                    self.client?.urlProtocol(self, didFailWithError: failure)
                }
            }
        }
    }
    
    override func stopLoading() { }
}

extension RequestMocking {
    
    private static var mocks: [MockedResponse] = []
    
    static func add(mock: MockedResponse) {
        mocks.append(mock)
    }
    
    static func removeAllMocks() {
        mocks.removeAll()
    }
    
    private static  func mock(for request: URLRequest) -> MockedResponse? {
        mocks.first { $0.url == request.url }
    }
}

// MARK: - RequestBlocking

private final class RequestBlocking: URLProtocol {
    enum Error: Swift.Error {
        case requestBlocked
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        DispatchQueue(label: "").async {
            self.client?.urlProtocol(self, didFailWithError: Error.requestBlocked)
        }
    }
    override func stopLoading() { }
}
