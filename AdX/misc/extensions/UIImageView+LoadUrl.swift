//
//  UIImageView+LoadUrl.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 16/09/2022.
//

import UIKit
import Combine

/// Loading image from an URL
/// This is a basic implementation that could be memory optimized
/// by using `Kingfisher` or `SDWebImage`library
///
extension UIImageView {
    
    func load(url: URL?, placeholder: UIImage? = nil) {
        image = placeholder
        guard let url = url else {
            return
        }
        
        disposables.forEach { $0.cancel() }
        disposables.removeAll()
        
        let repository = DIContainer.default.imageRepository
        repository.load(imageURL: url)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
            .store(in: &disposables)
    }
}

private extension UIImageView {
    
    private enum Holder {
        static var disposablesDict: [String: Set<AnyCancellable>] = [:]
    }
    
    private var disposables: Set<AnyCancellable> {
        get {
            Holder.disposablesDict[debugDescription] ?? Set<AnyCancellable>()
        }
        set(newValue) {
            Holder.disposablesDict[debugDescription] = newValue
        }
    }
}
