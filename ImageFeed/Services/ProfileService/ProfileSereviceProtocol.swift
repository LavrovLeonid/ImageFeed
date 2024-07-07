//
//  ProfileSereviceProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/17/24.
//

import Foundation

protocol ProfileSereviceProtocol {
    var profile: Profile? { get }
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    )
    func resetProfile()
}
