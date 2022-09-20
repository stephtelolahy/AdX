//
//  NavigatorProtocol.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 17/09/2022.
//

protocol NavigatorProtocol {
    func toDetails(_ ad: ClassifiedAd)
    func toFilter(_ filters: [CategoryFilter], completion: (([CategoryFilter]) -> Void)?)
    func dismiss()
}
