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
    
    private let viewModel: DetailsViewModel
    private var disposables = Set<AnyCancellable>()
    private let detailsView = DetailsView()
    
    // MARK: - Init
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        //        detailsView.update(viewModel: self.viewModel)
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
                // TODO: handle other states
            }
            .store(in: &disposables)
    }
}
