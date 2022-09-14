//
//  String+Localized.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Foundation

extension String {
    
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}
