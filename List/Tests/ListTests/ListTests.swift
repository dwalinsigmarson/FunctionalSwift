import XCTest
@testable import List

final class ListTests: XCTestCase {
	func testInitAddTop() {
		let list0 = List<Int>([])
		XCTAssertEqual(list0.top, nil, "List should be empty")
		
		let list1 = List<Int>([1])
		XCTAssertEqual(list1.top, 1, "List should have one node with 1")

		let list5 = List<Int>([1, 2, 3, 4, 5])
		let list5Res = diffNumIn(list5, first: 1, last: 5)
		XCTAssertNil(list5Res, "diff at num. \(list5Res!)")
	}
	
	func testIteration() {
		for _ in List<Int>([]) {
			XCTFail()
		}
	
		let list5 = List<Int>([1, 2, 3, 4, 5])
		var i = 1
		for elem in list5 {
			XCTAssertEqual(i, elem, "diff at num \(i)")
			i += 1
		}
	}

	func testDropFirst() {
		let list00 = List<Int>([]).dropFirst(0)
		XCTAssertEqual(list00.top, nil, "List should be empty")

		let list01 = List<Int>([]).dropFirst(1)
		XCTAssertEqual(list01.top, nil, "List should be empty")

		let list10 = List<Int>([1]).dropFirst(0)
		XCTAssertEqual(list10.top, 1, "List should be empty")

		let list11 = List<Int>([1]).dropFirst(1)
		XCTAssertEqual(list11.top, nil, "List should be empty")

		let listLong = List<Int>([1,2,3,4])
		
		let diffLong1 = diffNumIn(listLong.dropFirst(2), first: 3, last: 4)
		XCTAssertNil(diffLong1, "diff at num \(diffLong1!)")
		
		let diffLong2 = diffNumIn(listLong.dropFirst(3), first: 4, last: 4)
		XCTAssertNil(diffLong2, "diff at num \(diffLong2!)")

		XCTAssertNil(listLong.dropFirst(4).top, "")
	}

	static var allTests = [
		("testInit", testInitAddTop),
		("testIteration", testIteration)
	]
}

extension ListTests {
	// TODO:
	// XCTAssert... are not referential transparent, ha-ha-ha ))
	// To rewrite, when I adopt functional error propagation ))
	func diffNumIn(_ list: List<Int>, first: Int, last: Int) -> Int? {
		func go(_ list: List<Int>, _ i: Int) -> Int? {
			switch list {
			case .end:
				return i != last + 1 ? i : nil
			case .node(let elem, let list):
				return i > last || elem != i ?
					i : go(list, i + 1)
			}
		}
		
		return go(list, first)
	}
}
