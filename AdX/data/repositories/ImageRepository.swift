//
//  ImageRepository.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//
import Combine
import Foundation
import UIKit

protocol ImageRepositoryProtocol {
    func load(imageURL: URL) -> AnyPublisher<UIImage, Error>
}

struct ImageRepository: ImageRepositoryProtocol {
    
    let session: URLSession
    let bgQueue: DispatchQueue
    
    func load(imageURL: URL) -> AnyPublisher<UIImage, Error> {
        download(rawImageURL: imageURL)
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    }
    
    private func download(rawImageURL: URL) -> AnyPublisher<UIImage, Error> {
        session.dataTaskPublisher(for: URLRequest(url: rawImageURL))
            .requestData()
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw APIError.imageDeserialization
                }
                
                return image
            }
            .eraseToAnyPublisher()
    }
}
