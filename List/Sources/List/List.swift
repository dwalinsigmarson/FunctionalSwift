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

	func append(list:List<A>) -> List<A> {
		return self.foldRight(list) { (elem, list) -> List<A> in
			return .node(head: elem, tail: list)
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
		self.foldRight(List<B>.end) { (a: A, tail: List<B>) -> List<B> in
			List<B>.node(head: f(a), tail:tail)
		}
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
}

extension List where A: AdditiveArithmetic {
	func sum() -> A {
		return self.foldLeft(A.zero) { $0 + $1 }
	}
}
