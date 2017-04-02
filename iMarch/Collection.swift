//
//  Collection.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/17/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
