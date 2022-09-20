//
//  FilterViewController.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 17/09/2022.
//

import UIKit
import Combine

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: FilterViewModel!
    private var disposables = Set<AnyCancellable>()
    private var filters: [CategoryFilter] = []
    
    @UsesAutoLayout private var tableView = UITableView(frame: .zero, style: .plain)
    @UsesAutoLayout private var validateButton = UIButton(type: .custom)
    @UsesAutoLayout private var titleLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
    }
}

private extension FilterViewController {
    
    // MARK: - UI Setup
    
    func setupView() {
        view.backgroundColor = .systemGray6
        
        titleLabel.text = "filter_title".localized()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        
        validateButton.backgroundColor = .systemBlue
        validateButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        validateButton.addTarget(self, action: #selector(validateButtonTapped), for: .touchUpInside)
        view.addSubview(validateButton)
        
        NSLayoutConstraint.activate([
            validateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            validateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            validateButton.heightAnchor.constraint(equalToConstant: 44),
            validateButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        tableView.register(cellType: FilterCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: validateButton.topAnchor)
        ])
    }
    
    // MARK: Target action
    
    @objc
    private func validateButtonTapped() {
        viewModel.onValidate()
    }
    
    // MARK: - Binding
    
    func setupBindings() {
        viewModel.$filters
            .sink { [weak self] value in
                self?.filters = value
                self?.tableView.reloadData()
            }
            .store(in: &disposables)
        
        viewModel.resultsCountPublisher
            .sink { [weak self] value in
                self?.validateButton.setTitle(String(format: "filter_validate_button".localized(), value), for: .normal)
            }
            .store(in: &disposables)
    }
}

// MARK: - UITableViewDatasource

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FilterCell.self, for: indexPath)
        cell.update(with: filters[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onSelectItem(at: indexPath.row)
    }
}

private enum Constant {
    static let padding: CGFloat = 8
}
