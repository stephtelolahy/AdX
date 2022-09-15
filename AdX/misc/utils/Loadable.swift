//
//  Loadable.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 15/09/2022.
//

/// Wrapper for a loadable data
/// Typically used for a view state
///
enum Loadable<T> {
    case loading
    case loaded(T)
    case failed(Error)
}
