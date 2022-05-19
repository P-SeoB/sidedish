//
//  ConstantTest.swift
//  ConstantTest
//
//  Created by 박진섭 on 2022/05/20.
//

import XCTest

class ConstantTest: XCTestCase {

    func testConstantDescription()  {
        let point = Constant.SubInfoText.point.description
        let deliveryInfo = Constant.SubInfoText.deliveryInfo.description
        let deliveryFee = Constant.SubInfoText.deliveryFee.description
        
        XCTAssertEqual("적립금", point)
        XCTAssertEqual("배송정보", deliveryInfo)
        XCTAssertEqual("배송비", deliveryFee)
        
    }

}
