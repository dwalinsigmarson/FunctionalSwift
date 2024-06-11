//
//  ErrorsTests.swift
//
//
//  Created by Dmytro Davydenko on 10.06.2024.
//  Copyright © 2024 Dmytro Davydenko. All rights reserved.
//

import Foundation
import XCTest
@testable import Errors

final class ErrorsTests: XCTestCase {
	
	func testLift() {
		let a: Int? = 10
		XCTAssertEqual(lift { $0 * 2 }(a), 20)
		XCTAssertNil(lift { $0 * 2 }(nil))
	}

	func testMap2() {
		struct C: Equatable {
			let a: Int
			let b: String
		}

		func transform(a: Int, b: String) -> C {
			C(a: a, b: b)
		}

		let a: Int? = 10
		let b: String? = "test"
		XCTAssertEqual(map2(a, b, f: transform), C(a: 10, b: "test"))

		XCTAssertEqual(map2(nil, b, f: transform), nil)
		XCTAssertEqual(map2(a, nil, f: transform), nil)
	}
}
