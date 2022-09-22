//
//  DetailsView.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 16/09/2022.
//

import UIKit

class DetailsView: UIView {
    
    // MARK: - Properties
    
    @UsesAutoLayout private var scrollView = UIScrollView()
    @UsesAutoLayout private var contentView = UIView()
    @UsesAutoLayout private var imageView = UIImageView()
    @UsesAutoLayout private var contentStack = UIStackView()
    @UsesAutoLayout private var titleLabel = UILabel()
    @UsesAutoLayout private var descriptionLabel = UILabel()
    @UsesAutoLayout private var categoryLabel = UILabel()
    @UsesAutoLayout private var urgentLabel = UILabel()
    @UsesAutoLayout private var dateLabel = UILabel()
    @UsesAutoLayout private var cartButton = UIButton(type: .custom)
    
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
    
    func update(with item: ClassifiedAd) {
        imageView.load(url: URL(string: item.images.thumb), placeholder: UIImage(named: "image_placeholder"))
        titleLabel.text = item.title
        descriptionLabel.text = item.desc
        cartButton.setTitle(item.price.formattedPrice, for: .normal)
        categoryLabel.text = item.category.name
        urgentLabel.isHidden = !item.isUrgent
        if let creationDate = item.creationDate {
            let dateString = DateUtils.format(date: creationDate, with: "dd/MM/yyyy")
            dateLabel.text = String(format: "list_item_published_at".localized(), dateString)
        } else {
            dateLabel.text = nil
        }
    }
}

// MARK: - Setup View

private extension DetailsView {
    
    func setupView() {
        setupAddToCardButton()
        setupScrollView()
        setupImageView()
        setupContentStackView()
    }
    
    func setupAddToCardButton() {
        cartButton.setTitleColor(.white, for: .normal)
        cartButton.backgroundColor = .systemRed
        cartButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            cartButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 64),
            cartButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupScrollView() {
        // Scroll view
        scrollView.alwaysBounceVertical = true
        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addSubview(scrollView)
        
        // Content view
        scrollView.addSubview(contentView)
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
    
    func setupContentStackView() {
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 8
        contentView.addSubview(contentStack)
        
        urgentLabel.font = UIFont.boldSystemFont(ofSize: 14)
        urgentLabel.text = " \("list_item_urgent".localized().uppercased()) "
        urgentLabel.textColor = .white
        urgentLabel.backgroundColor = .systemRed
        urgentLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentStack.addArrangedSubview(urgentLabel)
        
        // Category label
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        categoryLabel.textColor = .darkGray
        categoryLabel.numberOfLines = 1
        categoryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentStack.addArrangedSubview(categoryLabel)
        
        // Title label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.numberOfLines = 0
        contentStack.addArrangedSubview(titleLabel)
        
        setupDescriptionView()
        setupDateView()
    }
    
    func setupDescriptionView() {
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.numberOfLines = 0
        contentStack.addArrangedSubview(descriptionLabel)
    }
    
    func setupDateView() {
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .darkGray
        dateLabel.numberOfLines = 0
        contentStack.addArrangedSubview(dateLabel)
    }
    
    func updateConstraints(for size: CGSize) {
        
        let headerHeight: CGFloat = max(1, (size.width / 750)) * Constant.headerMinHeight
        
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints.removeAll()
        
        activeConstraints.append(contentsOf: [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cartButton.topAnchor)
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
