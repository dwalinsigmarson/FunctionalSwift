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
	func testMap2() {
		struct C: Equatable {
			let a: Int
			let b: String
		}

		func transform(a: Int, b: String) -> C {
			C(a: a, b: b)
		}

		let a1: Int? = 10
		let b1: String? = "test"
		XCTAssertEqual(map2(a: a1, b: b1, f: transform), C(a: 10, b: "test"))

		XCTAssertEqual(map2(a: nil, b: b1, f: transform), nil)
		XCTAssertEqual(map2(a: a1, b: nil, f: transform), nil)
	}
}
