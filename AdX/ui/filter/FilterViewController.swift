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
    
    private let viewModel: FilterViewModel
    private var disposables = Set<AnyCancellable>()
    private var filters: [CategoryFilter] = []
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let validateButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    // MARK: - Init
    
    init(viewModel: FilterViewModel) {
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
        viewModel.onLoad()
    }
}

// MARK: - UI Setup

private extension FilterViewController {
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
        
        validateButton.translatesAutoresizingMaskIntoConstraints = false
        validateButton.setTitle(String(format: "filter_validate_button".localized(), 5), for: .normal)
        validateButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        validateButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        validateButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        validateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.addSubview(validateButton)
        
        NSLayoutConstraint.activate([
            validateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            validateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            validateButton.heightAnchor.constraint(equalToConstant: 44),
            validateButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cellType: CategoryCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGray6
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: validateButton.topAnchor)
        ])
    }
}

// MARK: - Binding

private extension FilterViewController {
    
    func makeDataSource() -> UITableViewDiffableDataSource<Int, CategoryFilter> {
        UITableViewDiffableDataSource<Int, CategoryFilter>(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(with: CategoryCell.self, for: indexPath)
            cell.update(with: item)
            return cell
        }
    }
    
    func setupBindings() {
        viewModel.$filters
            .sink { [weak self] value in
                self?.filters = value
                self?.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(with: CategoryCell.self, for: indexPath)
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
