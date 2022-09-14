//
//  DateUtils.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Foundation

enum DateUtils {
    static let dateFormatter = DateFormatter()
    
    /// Format Date with given template
    static func format(date: Date, with template: String) -> String {
        dateFormatter.dateFormat = template
        return dateFormatter.string(from: date)
    }
    
    /// Create Date from string with given template
    static func date(from string: String, with template: String) -> Date? {
        dateFormatter.dateFormat = template
        return dateFormatter.date(from: string)
        }
}
