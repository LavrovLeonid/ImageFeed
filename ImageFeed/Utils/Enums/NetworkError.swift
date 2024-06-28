//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/25/24.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodingError
}
