//
//  FunctionsTests.swift
//  
//
//  Created by Dmytro Davydenko on 14.03.2020.
//  Copyright © 2020 Dmytro Davydenko. All rights reserved.

import XCTest
@testable import Functions

final class FunctionsTests: XCTestCase {

	func testCurry() {
		XCTAssertEqual(curry(1, 2), 3)
	}
	
	static var allTests = [
		("testCurry", testCurry),
	]

}
