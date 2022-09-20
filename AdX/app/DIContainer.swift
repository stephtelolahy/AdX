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
    
    func resolveListViewController() -> ListViewController {
        let vc = ListViewController()
        let navigator = Navigator(vc, dependencies: self)
        let viewModel = ListViewModel(repository: adRepository, navigator: navigator)
        vc.viewModel = viewModel
        return vc
    }
    
    func resolveDetailsViewController(_ ad: ClassifiedAd) -> DetailsViewController {
        let vc = DetailsViewController()
        let viewModel = DetailsViewModel()
        viewModel.initialize(with: ad)
        vc.viewModel = viewModel
        return vc
    }
    
    func resolveFilterViewController(_ filters: [CategoryFilter], completion: (([CategoryFilter]) -> Void)?) -> FilterViewController {
        let vc = FilterViewController()
        let navigator = Navigator(vc, dependencies: self)
        let viewModel = FilterViewModel(navigator: navigator)
        viewModel.initialize(with: filters, completion: completion)
        vc.viewModel = viewModel
        return vc
    }
}
