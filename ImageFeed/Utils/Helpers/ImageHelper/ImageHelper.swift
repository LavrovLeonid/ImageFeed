//
//  ImageHelper.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit

struct ImageHelper: ImageHelperProtocol {
    func calcPropotionalHeight(by size: CGSize, width: CGFloat, edgeInsets: UIEdgeInsets) -> CGFloat {
        let imageViewWidth = width - edgeInsets.left - edgeInsets.right
        let imageWidth = size.width
        
        let scale = imageViewWidth / imageWidth
        let height = size.height * scale + edgeInsets.top + edgeInsets.bottom
        
        return height
    }
}
