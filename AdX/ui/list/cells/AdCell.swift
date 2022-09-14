//
//  AdCell.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import UIKit

class AdCell: UICollectionViewCell {
    
    // MARK: - SubViews
    
    private let contentStack = UIStackView()
    private let nameLabel = UILabel()
    private let mediaView = UIImageView()
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
        nameLabel.text = item.title
        mediaView.image = UIImage(named: "image_placeholder")
    }
}

private extension AdCell {
    
    func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 4.0
        setupContentStack()
        setupMediaView()
        setupNameLabel()
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
    
    func setupNameLabel() {
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentStack.addArrangedSubview(nameLabel)
    }
    
    func setupMediaView() {
        mediaView.layer.cornerRadius = 4
        mediaView.layer.masksToBounds = true
        mediaView.contentMode = .scaleAspectFit
        contentStack.addArrangedSubview(mediaView)
        
        NSLayoutConstraint.activate([
            mediaView.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            mediaView.heightAnchor.constraint(equalToConstant: 80.0)
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
