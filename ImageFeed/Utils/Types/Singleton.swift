//
//  Singleton.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/10/24.
//

import Foundation

protocol Singleton {
    associatedtype T
    
    static var shared: T { get }
}
