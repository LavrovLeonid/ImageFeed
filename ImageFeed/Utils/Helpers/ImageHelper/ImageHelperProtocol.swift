//
//  ImageHelperProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit

protocol ImageHelperProtocol {
    func calcPropotionalHeight(by size: CGSize, width: CGFloat, edgeInsets: UIEdgeInsets) -> CGFloat
}
