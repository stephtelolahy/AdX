//
//  DIContainer.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//
import Foundation

/// Providing dependencies with a Service locator pattern
/// This is a basic implementation that could be improved using `Resolver` library
///
struct DIContainer {
    let adRepository: AdRepositoryProtocol
    let imageRepository: ImageRepositoryProtocol
    
    static let `default` = resolveDependencies()
    
    func resolveAdListViewModel() -> AdListViewModel {
        AdListViewModel(repository: adRepository)
    }
}

private extension DIContainer {
    
    static func resolveDependencies() -> DIContainer {
        let session = configuredURLSession()
        let adRepository = configuredAdRepository(session: session)
        let imageRepository = configureImageRepository(session: session)
        
        return DIContainer(adRepository: adRepository, imageRepository: imageRepository)
    }
    
    static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    static func configuredAdRepository(session: URLSession) -> AdRepositoryProtocol {
        AdRepository(client: HTTPClient(session: session,
                                        baseURL: "https://raw.githubusercontent.com/leboncoin/paperclip/master",
                                        bgQueue: DispatchQueue(label: "bg_parse_queue")))
    }
    
    static func configureImageRepository(session: URLSession) -> ImageRepositoryProtocol {
        ImageRepository(session: session, bgQueue: DispatchQueue(label: "bg_parse_queue"))
    }
}
