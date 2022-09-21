//
//  Double+FormatPrice.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 21/09/2022.
//
import Foundation

extension Double {
    
    var formattedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "eur"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        let number = NSNumber(value: self)
        return formatter.string(from: number)
    }
}
