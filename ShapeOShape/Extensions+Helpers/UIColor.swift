//
//  UIColor.swift
//  ShapeOShape
//
//  Created by Daniel Aditya Istyana on 25/05/19.
//  Copyright © 2019 Daniel Aditya Istyana. All rights reserved.
//

import UIKit

extension UIColor {
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
