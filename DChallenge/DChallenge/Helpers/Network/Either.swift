//
//  Either.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import Foundation

/**
 Since *right* is synonymn with *correct*, if everything goes as expected, we populate the
 right case.
 */
public enum Either<T1, T2> {
    case left(T1)
    case right(T2)
}
