//
//  FontDictionary.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import Foundation
import UIKit

struct FontDictionary {
    static let semanticFonts =
    [
        "header1":UIFont(name: ".SFUIDisplay-Semibold", size: 18)!,
        "body":UIFont.systemFontOfSize(14, weight: UIFontWeightRegular),
        "bodyBold":UIFont.systemFontOfSize(15, weight: UIFontWeightBold),
        "header2":UIFont(name: ".SFUIDisplay-Semibold", size: 17)!,
        "header2Light":UIFont(name: ".SFUIDisplay-Regular", size: 17)!,
        "key":UIFont(name: ".SFUIDisplay-Semibold", size: 16)!,
        "value":UIFont(name: ".SFUIDisplay-Regular", size: 16)!,
        "captionText":UIFont.systemFontOfSize(12, weight: UIFontWeightRegular),
        "captionTitle":UIFont(name: ".SFUIText-Semibold", size: 15)!,
        "largeLight":UIFont(name: ".SFUIDisplay-Light", size: 30)!,
        "statusText":UIFont(name: ".SFUIDisplay-Light", size: 26)!
    ]
}