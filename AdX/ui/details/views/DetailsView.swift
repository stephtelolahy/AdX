//
//  DetailsView.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 16/09/2022.
//

import UIKit

class DetailsView: UIView {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let contentStack = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private var isInitialized: Bool = false
    private var activeConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isInitialized {
            isInitialized = true
            
            updateConstraints(for: bounds.size)
        }
    }
    
    // MARK: - Update
    
    func update(with ad: ClassifiedAd) {
        imageView.load(url: URL(string: ad.images.thumb), placeholder: UIImage(named: "image_placeholder"))
        titleLabel.text = ad.title
        descriptionLabel.text = ad.desc
    }
}

// MARK: - Setup View

private extension DetailsView {
    
    func setupView() {
        // Scroll view
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addSubview(scrollView)
        
        // Content view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // Stack View
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 16
        contentView.addSubview(contentStack)
        
        // Title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.numberOfLines = 0
        contentStack.addArrangedSubview(titleLabel)
        
        // Description label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.numberOfLines = 0
        contentStack.addArrangedSubview(descriptionLabel)
    }
    
    private func updateConstraints(for size: CGSize) {
        
        let headerHeight: CGFloat = max(1, (size.width / 750)) * Constant.headerMinHeight
        
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints.removeAll()
        
        activeConstraints.append(contentsOf: [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let isRegular = traitCollection.horizontalSizeClass == .regular
        let contentGuide = isRegular ? scrollView.readableContentGuide : scrollView.layoutMarginsGuide
        activeConstraints.append(contentsOf: [
            contentView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: contentGuide.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        activeConstraints.append(contentsOf: [
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        activeConstraints.append(contentsOf: [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
        
        NSLayoutConstraint.activate(activeConstraints)
    }
    
}

private enum Constant {
    static let headerMinHeight: CGFloat = 250
}
