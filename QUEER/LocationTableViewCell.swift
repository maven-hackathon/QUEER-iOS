//
//  LocationTableViewCell.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    var profileImageView:UIImageView!
    var nameLabel:UILabel!
    var tagsLabel:UILabel!
    var descriptionLabel:UILabel!
    var summaryArray:[String] = []
    var separatorView:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.profileImageView = UIImageView(frame: CGRectZero)
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.layer.cornerRadius = 6
        self.profileImageView.clipsToBounds = true
        self.profileImageView.backgroundColor = UIColor(white: 0.80, alpha: 1)
        self.profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.profileImageView)
        
        self.nameLabel = UILabel(frame: CGRectZero)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.text = "username"
        self.nameLabel.font = FontDictionary.semanticFonts["bodyBold"]
        self.nameLabel.numberOfLines = 0
        self.contentView.addSubview(self.nameLabel)
        
        self.tagsLabel = UILabel(frame: CGRectZero)
        self.tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tagsLabel.font = FontDictionary.semanticFonts["body"]
        self.tagsLabel.numberOfLines = 0
        self.contentView.addSubview(self.tagsLabel)
        
        self.descriptionLabel = UILabel(frame: CGRectZero)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.text = "short bio"
        self.descriptionLabel.font = FontDictionary.semanticFonts["body"]
        self.descriptionLabel.numberOfLines = 0
        self.contentView.addSubview(self.descriptionLabel)
        
        self.separatorView = UIView(frame: CGRectZero)
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.backgroundColor = ColorDictionary.interfaceTypeColors["separatorGrey"]
        self.contentView.addSubview(self.separatorView)
        
        let metricsDitcionary = ["sidePadding":7.5, "verticalPadding":17.5]
        let viewsDictionary = ["profileImageView":self.profileImageView, "nameLabel":self.nameLabel, "tagsLabel":self.tagsLabel,"separatorView":self.separatorView, "descriptionLabel":self.descriptionLabel]
        
        let firstRowHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[profileImageView(70)]-12.5-[nameLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDitcionary, views: viewsDictionary)
        self.contentView.addConstraints(firstRowHConstraints)
        
        let firstColumnConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[profileImageView(70)]->=verticalPadding-[separatorView(1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDitcionary, views: viewsDictionary)
        self.contentView.addConstraints(firstColumnConstraints)
        
        let secondColumnConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-22.5-[nameLabel]-3-[tagsLabel]-[descriptionLabel]", options: [NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: metricsDitcionary, views: viewsDictionary)
        self.contentView.addConstraints(secondColumnConstraints)
        
        let secondColumnBottomConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[descriptionLabel]->=verticalPadding-[separatorView(1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDitcionary, views: viewsDictionary)
        self.contentView.addConstraints(secondColumnBottomConstraints)
        
        let separatorWidthConstraint = NSLayoutConstraint(item: self.separatorView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        self.contentView.addConstraint(separatorWidthConstraint)
        
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
