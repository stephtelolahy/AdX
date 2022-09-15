//
//  DIContainer.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//
import Foundation
import UIKit

/// Providing dependencies with a Service locator pattern
/// This is a basic implementation that could be improved using `Resolver` library
///
struct DIContainer {
    let adRepository: AdRepositoryProtocol
    let imageRepository: ImageRepositoryProtocol
    
    static let `default` = initialize()
}

private extension DIContainer {
    
    static func initialize() -> DIContainer {
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

extension DIContainer: NavigatorDependencies {
    
    func resolveAdListViewController(navigator: NavigatorProtocol) -> AdListViewController {
        let viewModel = AdListViewModel(repository: adRepository, navigator: navigator)
        return AdListViewController(viewModel: viewModel)
    }
    
    func resolveAdDetailsViewController(_ ad: ClassifiedAd) -> AdDetailsViewController {
        let viewModel = AdDetailsViewModel()
        viewModel.initialize(with: ad)
        return AdDetailsViewController(viewModel: viewModel)
    }
}
