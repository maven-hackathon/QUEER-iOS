//
//  UIButtonExtension.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), forState: state)
    }
    
    func setBorderWithRoundedCorners(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = self.titleColorForState(UIControlState.Normal)?.CGColor
        self.layer.borderWidth = 0
        self.clipsToBounds = true
    }
    
    func setButtonType(type:String) {
        self.setBackgroundColor(ColorDictionary.interfaceTypeColors["normal"]!.darkenColor(0.1), forUIControlState: UIControlState.Highlighted)
        self.setBackgroundColor(ColorDictionary.interfaceTypeColors["normal"]!, forUIControlState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        if type == "mini"{
            self.titleLabel?.font = UIFont(name: ".SFUIText-Regular", size: 16)
        }
        self.titleEdgeInsets = UIEdgeInsetsMake(5.0, 7.5, 5.0, 7.5)
        self.setBorderWithRoundedCorners(6)
    }
    
}
