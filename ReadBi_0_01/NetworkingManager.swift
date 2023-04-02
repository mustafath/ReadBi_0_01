//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Mustafa Girgin on 14.03.2023.
//

import Foundation
import Combine
import Alamofire

class NetworkingManager {
    
    
    enum NetworkingError : LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch(self) {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response from URL: \(url)"
            case .unknown:
                return "[🤔] Unknown error occured."
            }
        }
    }
    
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        
       return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    static func downloadAF(url: URL, parameters: [String: Any]? = [:]) -> AnyPublisher<Data, Error> {
        return Future<Data, Error> { promise in
            AF.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseData(queue: DispatchQueue.global(qos: .default)) { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        
        return output.data;
    }
    
    static func handleCompletion(completion : Subscribers.Completion<Error>) {
        switch(completion) {
        case .finished:
            print("successful")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    
}
