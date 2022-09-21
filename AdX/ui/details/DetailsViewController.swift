//
//  DetailsViewController.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 15/09/2022.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: DetailsViewModel!
    private var disposables = Set<AnyCancellable>()
    
    @UsesAutoLayout private var detailsView = DetailsView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
    }
}

// MARK: - UI Setup

private extension DetailsViewController {
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(detailsView)
        
        NSLayoutConstraint.activate([
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Binding

private extension DetailsViewController {
    
    func setupBindings() {
        viewModel.$state
            .sink { [weak self] value in
                if case let .loaded(ad) = value {
                    self?.detailsView.update(with: ad)
                }
            }
            .store(in: &disposables)
    }
}
