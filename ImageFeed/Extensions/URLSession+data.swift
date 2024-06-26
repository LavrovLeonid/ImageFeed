//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = {
            result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: {
            data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print(String(data: data, encoding: .utf8) ?? "Network error") 
                    fulfillCompletionOnTheMainThread(
                        .failure(NetworkError.httpStatusCode(statusCode))
                    )
                }
            } else if let error = error {
                print("URL request error: ", error.localizedDescription)
                fulfillCompletionOnTheMainThread(
                    .failure(NetworkError.urlRequestError(error))
                )
            } else {
                print("URL session error")
                fulfillCompletionOnTheMainThread(
                    .failure(NetworkError.urlSessionError)
                )
            }
        })
        
        return task
    }
}
