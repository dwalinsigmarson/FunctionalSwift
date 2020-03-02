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

	func testDropWhile() {
		let list3 = List<Int>([1,2,3,4,5]).drop { $0 < 3 }
		let diffPosition5 = diffNumIn(list3, first: 3, last: 5)
		XCTAssertNil(diffPosition5, "diff at num \(diffPosition5!)")
		
		let list1 = List<Int>([1,2,3,4,5]).drop { $0 < 5 }
		let diffPosition1 = diffNumIn(list1, first: 5, last: 5)
		XCTAssertNil(diffPosition1, "diff at num \(diffPosition1!)")

		let list0 = List<Int>([1,2,3,4,5]).drop { $0 < 6 }
		XCTAssertNil(list0.top)
	}
	
	func testDropLast() {
		let list = List<Int>([1,2,3,4,5]).dropLast().dropLast()
		let diff = diffNumIn(list, first: 1, last: 3)
		XCTAssertNil(diff, "diff at num \(diff!)")
	}

	func testFoldLeft() {
		let list = List<Int>([5,4,3,2,1]).foldLeft(.end, f: List<Int>.node)
		let diff = diffNumIn(list, first: 1, last: 5)
		XCTAssertNil(diff, "diff at num \(diff!)")
	}
	
	func testFoldRight() {
		let list = List<Int>([1,2,3,4,5]).foldRight(.end, f: List<Int>.node)
		let diff = diffNumIn(list, first: 1, last: 5)
		XCTAssertNil(diff, "diff at num \(diff!)")
	}

	func testOtherFolds() {
		let diff1 = verifyFolds(withSource:List<Int>([1,2,3,4,5]), expectedResult: 1...5, method: List<Int>.foldRightExplicit)
		XCTAssertNil(diff1, "diff at num \(diff1!)")

		let diff2 = verifyFolds(withSource:List<Int>([5,4,3,2,1]), expectedResult: 1...5, method: List<Int>.foldLeftViaFoldRifgt)
		XCTAssertNil(diff2, "diff at num \(diff2!)")
	}
	
	func testDropLastN() {
		let list3 = List<Int>([1,2,3,4,5]).dropLast(2)
		let diff3 = diffNumIn(list3, first: 1, last: 3)
		XCTAssertNil(diff3, "diff at num \(diff3!)")

		let list0 = List<Int>([1,2,3,4,5]).dropLast(5)
		XCTAssertNil(list0.top, "")

		let list00 = List<Int>([1,2,3,4,5]).dropLast(6)
		XCTAssertNil(list00.top, "")

		let list5 = List<Int>([1,2,3,4,5]).dropLast(0)
		let diff5 = diffNumIn(list5, first: 1, last: 5)
		XCTAssertNil(diff5, "diff at num \(diff5!)")
	}
	
	func testAppend() {
		let list = List<Int>([1,2,3]).append(list: List<Int>([4,5,6]))
		let diff = diffNumIn(list, first: 1, last: 6)
		XCTAssertNil(diff, "diff at num \(diff!)")
	}
	
	func testLength() {
		XCTAssertEqual(0, List<Int>([]).length, "")
		XCTAssertEqual(1, List<Int>([1]).length, "")
		XCTAssertEqual(5, List<Int>([1,2,3,4,5]).length, "")
	}
	
	func testCopy() {
		let list5 = List<Int>([1,2,3,4,5]).copy()
		let diff5 = diffNumIn(list5, first: 1, last: 5)
		XCTAssertNil(diff5, "diff at num \(diff5!)")

		let list1 = List<Int>([1]).copy()
		let diff1 = diffNumIn(list1, first: 1, last: 1)
		XCTAssertNil(diff1, "diff at num \(diff1!)")

		let list0 = List<Int>([]).copy()
		XCTAssertNil(list0.top, "")
	}
	
	func testReversed() {
		let list5 = List<Int>([5,4,3,2,1]).reversed()
		let diff5 = diffNumIn(list5, first: 1, last: 5)
		XCTAssertNil(diff5, "diff at num \(diff5!)")

		let list1 = List<Int>([1]).reversed()
		let diff1 = diffNumIn(list1, first: 1, last: 1)
		XCTAssertNil(diff1, "diff at num \(diff1!)")

		let list0 = List<Int>([]).reversed()
		XCTAssertNil(list0.top, "")
	}
	
	func testMap() {
		let list = List<String>(["a", "aa", "aaa", "aaaa"]).map{ $0.count }
		let diff = diffNumIn(list, first: 1, last: 4)
		XCTAssertNil(diff, "diff at num \(diff!)")
	}
	
	func testFlatMap() {
		let list: List<Character> = List<(Character, Int)>([("a", 3), ("b", 2), ("c", 3), ("d", 4)]).flatMap {
			let (char, num) = $0
			return List<Character>([Character](repeating: char, count: num))
		}
		
		let expectedList = List<Character>(["a", "a", "a"])
		
		var resultIterator = list.makeIterator()
		var expectedIterator = expectedList.makeIterator()
		
		var resultElemOpt = resultIterator.next()
		var expectedElemOpt = expectedIterator.next()
		
		while let resultElem = resultElemOpt, let expectedElem = expectedElemOpt {
			XCTAssertEqual(resultElem, expectedElem)
			resultElemOpt = resultIterator.next()
			expectedElemOpt = expectedIterator.next()
		}
		
		XCTAssertNil(resultElemOpt)
		XCTAssertNil(expectedElemOpt)
	}
	
	func testSum() {
		XCTAssertEqual(0, List<Int>([]).sum(), "")
		XCTAssertEqual(5, List<Int>([5]).sum(), "")
		XCTAssertEqual(15, List<Int>([1,2,3,4,5]).sum(), "")
	}
	
	static var allTests = [
		("testInit", testInitAddTop),
		("testIteration", testIteration),
		("testDropFirst", testDropFirst),
		("testDropWhile", testDropWhile),
		("testDropLast", testDropLast),
		("testFoldLeft", testFoldLeft),
		("testFoldRight", testFoldRight),
		("testOtherFolds", testOtherFolds),
		("testDropLastN", testDropLastN),
		("testAppend", testAppend),
		("testLength", testLength),
		("testCopy", testCopy),
		("testReversed", testReversed),
		("testMap", testMap),
		("testSum", testSum)
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

	// In general:
	// function that receives method with type like foldRight(_:_)
	//	func verifyFoldRights<A, B>(name: String, method: (List<A>) -> (B, (A, B) -> B) -> List<A>) -> List<A> {
	//	}
	//
	// In this case
	func verifyFolds(withSource source: List<Int>, expectedResult: ClosedRange<Int>, method: (List<Int>) -> (List<Int>, @escaping (Int, List<Int>) -> List<Int>) -> List<Int>) -> Int? {
		let list = method(source)(.end, List<Int>.node)
		return diffNumIn(list, first: expectedResult.lowerBound, last: expectedResult.upperBound)
	}
}
