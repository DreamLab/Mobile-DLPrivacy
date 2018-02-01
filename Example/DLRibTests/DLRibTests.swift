//
//  DLRibTests.swift
//  DLRibTests
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import XCTest
@testable import DLRib

class DLRibTests: XCTestCase {

    let testedClass = ExampleClass()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExampleMethod_runMethod_checkItReturnedTrue() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        XCTAssertTrue(testedClass.exampleMethod())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
