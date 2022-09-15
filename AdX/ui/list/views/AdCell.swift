//
//  AdCell.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import UIKit
import Combine

class AdCell: UICollectionViewCell {
    
    // MARK: - SubViews
    
    private let contentStack = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    private let urgentLabel = UILabel()
    private let dateLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update
    
    func update(with item: ClassifiedAd) {
        titleLabel.text = item.title
        imageView.load(url: URL(string: item.images.small), placeholder: UIImage(named: "image_placeholder"))
    }
}

private extension AdCell {
    
    func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 4.0
        setupContentStack()
        setupImageView()
        setupTitleLabel()
        setupPriceView()
        setupDateView()
        setupUrgentView()
        setupCategoryView()
    }
    
    func setupContentStack() {
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 12
        contentStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentStack.addArrangedSubview(titleLabel)
    }
    
    func setupImageView() {
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        contentStack.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80.0)
        ])
    }
    
    func setupPriceView() {
        
    }
    
    func setupDateView() {
        
    }
    
    func setupUrgentView() {
        
    }
    
    func setupCategoryView() {
        
    }
}
