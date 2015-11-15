//
//  TextBlockWithIconTableViewCell.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit

class TextBlockWithIconTableViewCell: UITableViewCell {

    var headerLabel:UILabel!
    var bodyLabel:UILabel!
    var iconImageView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.headerLabel = UILabel(frame: CGRectZero)
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerLabel.font = FontDictionary.semanticFonts["bodyBold"]
        self.contentView.addSubview(self.headerLabel)
        
        self.bodyLabel = UILabel(frame: CGRectZero)
        self.bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bodyLabel.font = FontDictionary.semanticFonts["body"]
        self.bodyLabel.numberOfLines = 0
        self.contentView.addSubview(self.bodyLabel)
        
        self.iconImageView = UIImageView(frame: CGRectZero)
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.iconImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.iconImageView.tintColor = ColorDictionary.interfaceTypeColors["normal"]
        self.contentView.addSubview(self.iconImageView)
        
        let metricsDictionary = ["sidePadding":15, "verticalPadding":12.5]
        let viewsDictionary = ["headerLabel":self.headerLabel, "bodyLabel":self.bodyLabel, "iconImageView":self.iconImageView]
        
        let headerHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[headerLabel]-[iconImageView(36)]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        let iconImageViewHeightConstraint = NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 36)
        let iconImageViewVerticalCenterConstraint = NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let bodyHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[headerLabel]-[iconImageView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[headerLabel]-5-[bodyLabel]-verticalPadding-|", options: [NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        
        self.contentView.addConstraints(headerHorizontalConstraints)
        self.contentView.addConstraint(iconImageViewHeightConstraint)
        self.contentView.addConstraint(iconImageViewVerticalCenterConstraint)
        self.contentView.addConstraints(bodyHorizontalConstraints)
        self.contentView.addConstraints(verticalConstraints)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
