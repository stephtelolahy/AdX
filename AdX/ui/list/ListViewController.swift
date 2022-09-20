//
//  ListViewController.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: ListViewModel!
    private lazy var dataSource = makeDataSource()
    private var disposables = Set<AnyCancellable>()
    
    @UsesAutoLayout private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var filterButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        viewModel.onLoad()
    }
}

// MARK: - UI Setup

private extension ListViewController {
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        title = "list_title".localized()
        
        collectionView.register(cellType: AdCell.self)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6
        collectionView.contentInset = UIEdgeInsets(top: Constant.padding, left: Constant.padding, bottom: Constant.padding, right: Constant.padding)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        filterButton = UIBarButtonItem(title: "".localized(), style: .done, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItems = [filterButton]
    }
    
    @objc
    func filterTapped() {
        viewModel.onFilter()
    }
}

// MARK: - Binding

private extension ListViewController {
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Int, ClassifiedAd> {
        UICollectionViewDiffableDataSource<Int, ClassifiedAd>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(with: AdCell.self, for: indexPath)
            cell.update(with: item)
            return cell
            
        }
    }
    
    func setupBindings() {
        viewModel.$state
            .sink { [weak self] value in
                if case let .loaded(items) = value {
                    var snapshot = NSDiffableDataSourceSnapshot<Int, ClassifiedAd>()
                    snapshot.appendSections([0])
                    snapshot.appendItems(items, toSection: 0)
                    self?.dataSource.apply(snapshot)
                }
                // TODO: handle other states
            }
            .store(in: &disposables)
        
        viewModel.filtersCountPublisher
            .sink { [weak self] value in
                let count: String = value > 0 ? String(value) : "+"
                self?.filterButton.title = "\("filter_filter_button".localized()) (\(count))"
                
            }
            .store(in: &disposables)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell = UIDevice.current.userInterfaceIdiom == .pad ? Constant.iPadItemsPerRow : Constant.iPhoneItemsPerRow
        let cellWidth = (UIScreen.main.bounds.size.width - (numberOfCell + 2) * Constant.padding) / numberOfCell
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.onSelectItem(at: indexPath.item)
    }
}

private enum Constant {
    static let iPhoneItemsPerRow: CGFloat = 2
    static let iPadItemsPerRow: CGFloat = 3
    static let padding: CGFloat = 8
}
