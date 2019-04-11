//
//  Misc.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/17.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

class Misc: NSObject {

}


public extension UIColor {
    
//    convenience init(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) {
//        self.init(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
//    }
    
//    static func rgb(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
//        return rgba((r), (g), (b), 1)
//    }
//
//    static var rand: UIColor {
//        return rgb(CGFloat(arc4random_uniform(255)), CGFloat(arc4random_uniform(255)), CGFloat(arc4random_uniform(255)))
//    }
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}


public extension UILabel {
    
    
    convenience init(_ textColor: UIColor, _ font: UIFont) {
        self.init(textColor, font, NSTextAlignment.left)
    }
    
    convenience init(_ textColor: UIColor, _ font: UIFont, _ textAlignment: NSTextAlignment) {
        self.init()
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
    }
    
}
