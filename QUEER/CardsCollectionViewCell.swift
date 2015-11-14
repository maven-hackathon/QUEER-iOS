//
//  CardsCollectionViewCell.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import KDEDateLabel

class CardsCollectionViewCell: UICollectionViewCell {
    
    var cardView:UIView!
    var backgroundImageView:UIImageView!
    
    var cardContentCanvasView:UIVisualEffectView!
    var locationNameLabel:UILabel!
    var tagsCollectionView:UICollectionView!
    var locationSummaryLabel:UILabel!
    var readMoreButton:UIButton!
    
    
    var cellWidth:CGFloat = UIScreen.mainScreen().bounds.width
    let sidePadding:CGFloat = 10
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cardView = UIView(frame: CGRectZero)
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.backgroundColor = UIColor.whiteColor()
        self.cardView.clipsToBounds = true
        self.cardView.layer.cornerRadius = 6
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.borderColor = UIColor(white: 1, alpha: 0.2).CGColor
        self.contentView.addSubview(self.cardView)
        
        self.backgroundImageView = UIImageView(frame: CGRectZero)
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroundImageView.image = UIImage(named: "backgroundImagePlaceholder")
        self.cardView.addSubview(self.backgroundImageView)
        
        self.cardContentCanvasView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        self.cardContentCanvasView.frame = CGRectZero
        self.cardContentCanvasView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.addSubview(self.cardContentCanvasView)
        
        self.locationNameLabel = UILabel(frame: CGRectZero)
        self.locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.locationNameLabel.text = "Name"
        self.locationNameLabel.numberOfLines = 0
        self.locationNameLabel.font = FontDictionary.semanticFonts["bodyBold"]
        self.cardContentCanvasView.addSubview(self.locationNameLabel)
        
        let layout = UICollectionViewLayout()
        self.tagsCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.cardContentCanvasView.addSubview(self.tagsCollectionView)
        
        self.locationSummaryLabel = UILabel(frame: CGRectZero)
        self.locationSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.locationSummaryLabel.text = "Summary"
        self.locationSummaryLabel.numberOfLines = 0
        self.locationSummaryLabel.font = FontDictionary.semanticFonts["body"]
        self.cardContentCanvasView.addSubview(self.locationSummaryLabel)
        
        self.readMoreButton = UIButton(frame: CGRectZero)
        self.readMoreButton.translatesAutoresizingMaskIntoConstraints = false
        self.readMoreButton.setTitle("Read More", forState: UIControlState.Normal)
        self.readMoreButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.readMoreButton.setButtonType("normal")
        self.cardContentCanvasView.addSubview(self.readMoreButton)
        
        
        let metricsDictionary = ["verticalPadding":5, "cardWidth":self.cellWidth - self.sidePadding * 2, "cardHeight":self.cellWidth - self.sidePadding * 2, "sidePadding":self.sidePadding]
        
        let canvasViewsDictionary = ["cardView":self.cardView]
        
        
        let baseHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[cardView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: canvasViewsDictionary)

        let baseVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[cardView(cardHeight)]|", options: [NSLayoutFormatOptions.AlignAllLeft,NSLayoutFormatOptions.AlignAllRight], metrics: metricsDictionary, views: canvasViewsDictionary)
        
        self.contentView.addConstraints(baseHConstraints)
        self.contentView.addConstraints(baseVConstraints)
        
        let cardViewViewsDictionary = ["backgroundImageView":self.backgroundImageView, "cardContentCanvasView":self.cardContentCanvasView, "locationNameLabel":self.locationNameLabel, "tagsCollectionView":self.tagsCollectionView, "locationSummaryLabel":self.locationSummaryLabel, "readMoreButton":self.readMoreButton]

        let cardViewMetricsDictionary = ["sidePadding":15, "topPadding":20]
        
        let cardViewBackgroundHConstriants = NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: cardViewViewsDictionary)
        self.cardView.addConstraints(cardViewBackgroundHConstriants)

        let cardViewBackgroundVConstriants = NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: cardViewViewsDictionary)
        self.cardView.addConstraints(cardViewBackgroundVConstriants)
        
        let cardContentCanvasViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[cardContentCanvasView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: cardViewViewsDictionary)
        self.cardView.addConstraints(cardContentCanvasViewHConstraints)
        
        let cardContentCanvasViewVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[cardContentCanvasView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: cardViewViewsDictionary)
        self.cardView.addConstraints(cardContentCanvasViewVConstraints)
        
        let cardContentCanvasViewHInternalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[locationNameLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: cardViewMetricsDictionary, views: cardViewViewsDictionary)
        self.cardContentCanvasView.addConstraints(cardContentCanvasViewHInternalConstraints)
        
        let cardContentCanvasViewVInternalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topPadding-[locationNameLabel]-4-[locationSummaryLabel]-15-[readMoreButton(44)]-sidePadding-|", options: [NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: cardViewMetricsDictionary, views: cardViewViewsDictionary)
        self.cardContentCanvasView.addConstraints(cardContentCanvasViewVInternalConstraints)
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        attr.frame = CGRect(x: 0.0, y: 0.0, width: self.cellWidth, height:self.cellWidth - self.sidePadding * 2)
        return attr
    }

}
