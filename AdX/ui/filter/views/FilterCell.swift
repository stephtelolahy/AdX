//
//  FilterCell.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 17/09/2022.
//

import UIKit

class FilterCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with filter: CategoryFilter) {
        textLabel?.text = "\(filter.name) (\(filter.count))"
        accessoryType = filter.isSelected ? .checkmark : .none
    }
}
