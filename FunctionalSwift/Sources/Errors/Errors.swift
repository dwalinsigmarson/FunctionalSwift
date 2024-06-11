//
//  Errors.swift
//
//
//  Created by Dmytro Davydenko on 10.06.2024.
//  Copyright © 2024 Dmytro Davydenko. All rights reserved.
//

import Foundation
import Functions

func lift<A, B>(f: @escaping (A) -> B) -> (A?) -> B? {
	return {	$0.map(f)	}
}

func map2<A, B, C>(_ a: A?, _ b: B?, f: (A, B) -> C) -> C? {
	a.flatMap({ (a) -> C? in
		b.flatMap { (b) -> C in
			f(a, b)
		}
	})
}
