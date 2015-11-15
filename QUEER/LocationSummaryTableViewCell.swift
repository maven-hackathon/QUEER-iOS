//
//  LocationSummaryTableViewCell.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit

class LocationSummaryTableViewCell: UITableViewCell {
    var profileImageView:UIImageView!
    var nameLabel:UILabel!
    var bioDescriptionLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.profileImageView = UIImageView(frame: CGRectZero)
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.layer.cornerRadius = 44
        self.profileImageView.clipsToBounds = true
        self.profileImageView.backgroundColor = ColorDictionary.interfaceTypeColors["borderGrey"]
        self.profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.profileImageView)
        
        self.nameLabel = UILabel(frame: CGRectZero)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.text = "name"
        self.nameLabel.textAlignment = NSTextAlignment.Center
        self.nameLabel.numberOfLines = 0
        self.nameLabel.font = FontDictionary.semanticFonts["header2"]
        self.contentView.addSubview(self.nameLabel)
        
        self.bioDescriptionLabel = UILabel(frame: CGRectZero)
        self.bioDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bioDescriptionLabel.text = "bio or description"
        self.bioDescriptionLabel.numberOfLines = 0
        self.bioDescriptionLabel.font = FontDictionary.semanticFonts["body"]
        self.bioDescriptionLabel.textAlignment = NSTextAlignment.Left
        self.contentView.addSubview(self.bioDescriptionLabel)
        
        let metricsDictionary = ["verticalPadding":25, "sidePadding":25]
        let viewsDictionary = ["profileImageView":self.profileImageView, "nameLabel":self.nameLabel, "bioDescriptionLabel":self.bioDescriptionLabel]
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[profileImageView(88)]-15-[nameLabel]-6-[bioDescriptionLabel]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(verticalConstraints)
        
        let profileImageViewWidthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[profileImageView(88)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(profileImageViewWidthConstraint)
        
        let profileImageViewCenterXConstraint = NSLayoutConstraint(item: self.profileImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.contentView.addConstraint(profileImageViewCenterXConstraint)
        
        let nameLabelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[nameLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(nameLabelHorizontalConstraints)
        
        let bioDescriptionLabelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[bioDescriptionLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(bioDescriptionLabelHorizontalConstraints)
        
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
