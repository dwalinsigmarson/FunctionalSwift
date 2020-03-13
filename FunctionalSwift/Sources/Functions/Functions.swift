//
//  Functions.swift
//  
//
//  Created by Dmytro Davydenko on 13.03.2020.
//  Copyright © 2020 Dmytro Davydenko. All rights reserved.

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
	return { (a: A) -> (B) -> C in
		return { (b: B) -> C in
			return f(a, b)
		}
	}
}
