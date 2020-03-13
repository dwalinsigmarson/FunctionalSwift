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
		func originalFunction(_ a: Int, _ b: String) -> String {
			"\(b) is \(a)"
		}

		let curriedFunction = curry(originalFunction)

		let arg1 = 10
		let arg2 = "Length"
		
		XCTAssertEqual(curriedFunction(arg1)(arg2), originalFunction(arg1, arg2))
	}
	
	static var allTests = [
		("testCurry", testCurry),
	]
}
