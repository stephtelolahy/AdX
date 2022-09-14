//
//  NSObject+ClassName.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Foundation

/// Getting a class name as String
///
/// Example :
/// UIView.className   //=> "UIView"
/// UILabel().className //=> "UILabel"
///
protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        String(describing: self)
    }
    
    var className: String {
        type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {
}
