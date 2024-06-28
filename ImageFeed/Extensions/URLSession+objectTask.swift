//
//  URLSession+objectTask.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/25/24.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    
                    do {
                        completion(.success(
                            try decoder.decode(
                                T.self,
                                from: data
                            ))
                        )
                    } catch let error {
                        print(
                            "Decoding Error: ",
                            error.localizedDescription,
                            String(data: data, encoding: .utf8) ?? ""
                        )
                        completion(.failure(NetworkError.decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        
        return task
    }
}
