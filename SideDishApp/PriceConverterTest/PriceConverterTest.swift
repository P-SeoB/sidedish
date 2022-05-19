//
//  PriceConverterTest.swift
//  PriceConverterTest
//
//  Created by 박진섭 on 2022/05/19.
//

import XCTest

class PriceConverterTest: XCTestCase {
    
    func tesToDecimal() {
        let testString = "2,000원"
        let numberFromTestString = PriceConvertor.toDecimal(from: testString)
        let expectedNumber = 2000
        
        XCTAssertEqual(numberFromTestString, expectedNumber)
    }
    
    
    func testToString() {
        let testNumber = 2000
        let stringFromTestNumber = PriceConvertor.toString(from: testNumber)
        let expectedString = "2,000원"
        
        XCTAssertEqual(stringFromTestNumber, expectedString)
    }

}
