//
//  AdListViewController.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import UIKit
import Combine

class AdListViewController: UIViewController {
    
    // MARK: - SubViews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Properties
    
    private lazy var viewModel: AdListViewModel = DIContainer.default.resolveAdListViewModel()
    private lazy var dataSource = makeDataSource()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        viewModel.onLoad()
    }
}

// MARK: - UI Setup

private extension AdListViewController {
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Int, ClassifiedAd> {
        UICollectionViewDiffableDataSource<Int, ClassifiedAd>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(with: AdCell.self, for: indexPath)
            cell.update(with: item)
            return cell
            
        }
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        title = "ad_list_title".localized()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    }
}

// MARK: - Binding

private extension AdListViewController {
    
    func setupBindings() {
        viewModel.$ads
            .sink { [weak self] items in
                var snapshot = NSDiffableDataSourceSnapshot<Int, ClassifiedAd>()
                snapshot.appendSections([0])
                snapshot.appendItems(items, toSection: 0)
                self?.dataSource.apply(snapshot)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AdListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell = UIDevice.current.userInterfaceIdiom == .pad ? Constant.iPadItemsPerRow : Constant.iPhoneItemsPerRow
        let cellWidth = (UIScreen.main.bounds.size.width - (numberOfCell + 2) * Constant.padding) / numberOfCell
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

private enum Constant {
    static let iPhoneItemsPerRow: CGFloat = 2
    static let iPadItemsPerRow: CGFloat = 3
    static let padding: CGFloat = 8
}
