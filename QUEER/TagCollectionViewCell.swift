//
//  TagCollectionViewCell.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    var tagLabel:UILabel!
    let sidePadding:CGFloat = 10
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.backgroundColor = ColorDictionary.interfaceTypeColors["normal"]
        
        self.tagLabel = UILabel(frame: CGRectZero)
        self.tagLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tagLabel.text = "Tag"
        self.tagLabel.textColor = UIColor.whiteColor()
        self.tagLabel.font = FontDictionary.semanticFonts["body"]
        self.contentView.addSubview(self.tagLabel)
        
        let metricsDictionary = ["sidePadding":self.sidePadding, "verticalPadding":5]
        let viewsDictionary = ["tagLabel":self.tagLabel]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[tagLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[tagLabel]-verticalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        
        self.contentView.addConstraints(horizontalConstraints)
        self.contentView.addConstraints(verticalConstraints)
        
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        let size = self.tagLabel.sizeThatFits(CGSize(width: CGFloat.max, height: attr.frame.size.height))
        attr.frame = CGRect(x: 0.0, y: 0.0, width: size.width + self.sidePadding * 2, height:CGRectGetHeight(attr.frame))
        return attr
    }

}
