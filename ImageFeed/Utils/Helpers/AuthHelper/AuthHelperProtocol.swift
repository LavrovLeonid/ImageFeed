//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/12/24.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
