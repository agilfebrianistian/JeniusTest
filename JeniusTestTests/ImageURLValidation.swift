//
//  ImageURLValidation.swift
//  JeniusTestTests
//
//  Created by Agil Febrianistian on 20/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import XCTest
@testable import JeniusTest

class ImageURLValidation: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testValidImageURL() {
        
        let invalidURL = ""
        let invalidURL2 = "N/A"

        let validURL = "https://pbs.twimg.com/profile_images/472442266062045184/YyLIIsD5_400x400.jpeg"
        
        XCTAssertEqual(invalidURL.isValidURL, false)
        XCTAssertEqual(invalidURL2.isValidURL, false)

        XCTAssertEqual(validURL.isValidURL, true)
    }


    

}
