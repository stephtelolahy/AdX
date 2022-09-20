//
//  UsesAutoLayout.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 20/09/2022.
//
import UIKit

/// Auto Layout Property Wrapper
@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
