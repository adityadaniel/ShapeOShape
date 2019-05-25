//
//  Array+Differences.swift
//  ShapeOShape
//
//  Created by Daniel Aditya Istyana on 25/05/19.
//  Copyright © 2019 Daniel Aditya Istyana. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
