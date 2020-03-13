//
//  List.swift
//  FunctionalSwift
//
//  Created by Dmytro Davydenko on 2/18/20.
//  Copyright © 2020 Dmytro Davydenko. All rights reserved.

enum List<A> : Sequence {
	
	case end
	indirect case node(head: A, tail: List<A>)
	
	init<T: Sequence>(_ sequence: T) where T.Element == A {
		self = .end
		sequence.reversed().forEach {
			self = self.add($0)
		}
	}
	
	var top: A? {
		switch self {
		case .end:
			return nil
		case .node(let head, _):
			return head
		}
	}
	
	var tail: List<A> {
		switch self {
		case .end:
			return self
		case .node(_, let tail):
			return tail
		}
	}
	
	func makeIterator() -> ListIterator<A> {
		return ListIterator(list: self)
	}
	
	func add(_ a: A) -> List<A> {
		.node(head: a, tail: self)
	}
	
	func dropFirst(_ n: Int) -> List<A> {
		if n == 0 {
			return self
		}
		
		switch self {
		case .end:
			return self
		case .node(_, let tail):
			return tail.dropFirst(n - 1)
		}
	}

	func drop(while predicate: (A) -> Bool) -> List<A> {
		switch self {
		case .end:
			return self
		case .node(let a, let tail):
			return predicate(a) ? tail.drop(while: predicate) : self
		}
	}
	
	func dropLast() -> List<A> {
		switch self {
		case .end:
			return self
		case .node(_, .end):
			return .end
		case .node(let n, let tail):
			return .node(head: n, tail: tail.dropLast())
		}
	}
	
	func dropLast(_ n: Int) -> List<A> {
		let (_, resultList) = self.foldRight((0, .end)) { (elem, accum) -> (Int, List<A>) in
			let (depth, list) = accum

			if (depth < n) {
				return (depth + 1, .end)
			} else {
				return (depth, .node(head: elem, tail: list))
			}
		}
		
		return resultList
	}
	
	func foldLeft<B>(_ b: B, f: (A, B) -> B) -> B {
		switch self {
		case .end:
			return b
		case .node(let a, let tail):
			return tail.foldLeft(f(a, b), f: f)
		}
	}
	
	func foldRight<B>(_ b: B, f: (A, B) -> B) -> B {
		return self.foldLeft(Self.end, f: Self.node).foldLeft(b, f: f)
	}

	/// list parameter is shared with the result, self is copied
	func append(list: List<A>) -> List<A> {
		self.foldRight(list) { (elem, list) -> List<A> in
			list.add(elem) // .node(head: elem, tail: list)
		}
	}

	var length: Int {
		self.foldLeft(0) { $1 + 1 }
	}
	
	func copy() -> List<A> {
		self.foldRight(Self.end, f: Self.node)
	}
	
	func reversed() -> List<A> {
		self.foldLeft(Self.end, f: Self.node)
	}

	func map<B>(f: (A) -> B) -> List<B> {
		self.foldRight(List<B>.end) { (a: A, list: List<B>) -> List<B> in
			list.add(f(a)) //	List<B>.node(head: f(a), tail:list)
		}
	}
	
	func flatMap<B>(f: (A) -> List<B>) -> List<B> {
		self.foldRight(List<B>.end) { (a: A, tailList: List<B> ) -> List<B> in
			f(a).append(list: tailList)
		}
	}
	
	func filter(f: (A) -> Bool) -> List<A> {
		flatMap { f($0) ? .node(head: $0, tail: .end) : .end }
	}
}

func zip<A, B, C>(_ listA: List<A>, _ listB: List<B>, with f: (A, B) -> C) -> List<C> {
	switch (listA, listB) {
	case (_, .end):
		return .end
	case (.end, _):
		return .end
	case (.node(let a, let tailA), .node(let b, let tailB)):
		return .node(head: f(a, b), tail: zip(tailA, tailB, with: f))
	}
}

struct ListIterator<A> : IteratorProtocol {
	typealias Element = A
	
	var list: List<A>
	
	mutating func next() -> A? {
		switch list {
		case .end:
      	return nil
		case .node(let head, let tail):
			list = tail
			return head
		}
	}
}

extension List where A: Equatable {
	func hasSubsequence(_ list: List<A>) -> Bool {
		let suffix = self.drop { (a: A) in
			switch list {
			case .end:
				return false
			case .node(a, _):
				return false
			default:
				return true
			}
		}

		let result = zip(list, suffix) { $0 == $1 }.foldLeft(true) { $0 && $1 }
		return result
	}
}

extension List {
	func foldRightExplicit<B>(_ b: B, f: (A, B) -> B) -> B {
		switch self {
		case .end:
			  return b
		case .node(let a, let tail):
			  return f(a, tail.foldRight(b, f: f))
		}
	}
	
	func foldLeftViaFoldRifgt<B>(_ b: B,  f: @escaping (A, B) -> B) -> B {
		self.foldRightExplicit({ $0 }) { (elem: A, accum: @escaping (B) -> B ) -> ((B) -> B) in
			return { (b: B) -> B in
				return accum(f(elem, b))
			}
		}(b)
	}

	func flatMapViaFoldLeft<B>(f: (A) -> List<B>) -> List<B> {
		self.foldLeft(List<B>.end) { (a: A, list: List<B>) -> List<B> in
			list.append(list: f(a))
		}
	}
}

extension List where A: AdditiveArithmetic {
	func sum() -> A {
		return self.foldLeft(A.zero) { $0 + $1 }
	}
}
