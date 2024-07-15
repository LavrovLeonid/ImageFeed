//
//  ImageHelperTests.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import XCTest
@testable import ImageFeed

final class ImageHelperTests: XCTestCase {
    func testCalcPropotionalHeightLandscape() {
        //given
        let imageHelper = ImageHelper()
        
        //when
        let height = imageHelper.calcPropotionalHeight(
            by: .init(width: 1000, height: 500),
            width: 300
        )
        
        print(height)
        
        //then
        XCTAssertEqual(height, 150)
    }
    
    func testCalcPropotionalHeightPortrait() {
        //given
        let imageHelper = ImageHelper()
        
        //when
        let height = imageHelper.calcPropotionalHeight(
            by: .init(width: 500, height: 1000),
            width: 300
        )
        print(height)
        
        //then
        XCTAssertEqual(height, 600)
    }
}
