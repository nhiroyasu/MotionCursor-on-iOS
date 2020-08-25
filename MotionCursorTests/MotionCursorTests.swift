//
//  MotionCursorTests.swift
//  MotionCursorTests
//
//  Created by NH on 2020/08/25.
//  Copyright © 2020 NH. All rights reserved.
//

import XCTest
@testable import MotionCursor

class MotionCursorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testMouseInfoのエンコードがうまくいくか() throws {
        let acc = AccParam(x: 30.1, y: 20.9, z: 10.0)
        let testMotion = MotionCursor.MouseInfo(type: MotionCursor.MOUSE_TYPE.NORMAL.rawValue, acc: acc)
        XCTAssertNoThrow(try encodeMouseInfo(mouseInfo: testMotion))
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
