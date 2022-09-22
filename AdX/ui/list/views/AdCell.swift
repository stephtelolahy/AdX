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
    
    @UsesAutoLayout private var contentStack = UIStackView()
    @UsesAutoLayout private var imageView = UIImageView()
    @UsesAutoLayout private var titleLabel = UILabel()
    @UsesAutoLayout private var priceLabel = UILabel()
    @UsesAutoLayout private var categoryLabel = UILabel()
    @UsesAutoLayout private var urgentLabel = UILabel()
    @UsesAutoLayout private var dateLabel = UILabel()
    
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
        categoryLabel.text = item.category.name
        urgentLabel.isHidden = !item.isUrgent
        priceLabel.text = item.price.formattedPrice
        
        if let creationDate = item.creationDate {
            let dateString = DateUtils.format(date: creationDate, with: "dd/MM/yyyy")
            dateLabel.text = String(format: "list_item_published_at".localized(), dateString)
        } else {
            dateLabel.text = nil
        }
    }
}

private extension AdCell {
    
    func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 4.0
        
        setupUrgentView()
        setupImageView()
        setupContentStack()
        setupTitleView()
        setupCategoryView()
        setupPriceView()
        setupDateView()
    }
    
    func setupUrgentView() {
        urgentLabel.font = UIFont.boldSystemFont(ofSize: 14)
        urgentLabel.text = " \("list_item_urgent".localized().uppercased()) "
        urgentLabel.textColor = .white
        urgentLabel.backgroundColor = .systemRed
        urgentLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(urgentLabel)
        
        NSLayoutConstraint.activate([
            urgentLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            urgentLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        ])
    }
    
    func setupImageView() {
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: urgentLabel.bottomAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 80.0)
        ])
    }
    
    func setupContentStack() {
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    func setupCategoryView() {
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        categoryLabel.textColor = .darkGray
        categoryLabel.numberOfLines = 1
        categoryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentStack.addArrangedSubview(categoryLabel)
    }
    
    func setupTitleView() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentStack.addArrangedSubview(titleLabel)
    }
    
    func setupPriceView() {
        priceLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        priceLabel.textColor = .systemRed
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentStack.addArrangedSubview(priceLabel)
    }
    
    func setupDateView() {
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .darkGray
        dateLabel.numberOfLines = 0
        contentStack.addArrangedSubview(dateLabel)
    }
}
