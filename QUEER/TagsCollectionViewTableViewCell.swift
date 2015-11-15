//
//  TagsCollectionViewTableViewCell.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/14/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class TagsCollectionViewTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var tagsTypeLabel:UILabel!
    var tagsCollectionView:UICollectionView!
    var tagsArray:[String]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.contentView.clipsToBounds = false
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize  = CGSizeMake(50, 28)
        layout.minimumInteritemSpacing = 7.5
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        self.tagsTypeLabel = UILabel(frame: CGRectZero)
        self.tagsTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tagsTypeLabel.font = FontDictionary.semanticFonts["bodyBold"]
        self.contentView.addSubview(self.tagsTypeLabel)
        
        self.tagsCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.tagsCollectionView.alwaysBounceHorizontal = true
        self.tagsCollectionView.showsHorizontalScrollIndicator = false
        self.tagsCollectionView.contentInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        self.tagsCollectionView.registerClass(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCollectionViewCell")
        self.tagsCollectionView.backgroundColor = UIColor.clearColor()
        self.tagsCollectionView.backgroundView = UIView(frame: CGRectZero)
        self.tagsCollectionView.scrollsToTop = false
        self.tagsCollectionView.delegate = self
        self.tagsCollectionView.dataSource = self
        self.tagsCollectionView.clipsToBounds = false
        self.contentView.addSubview(self.tagsCollectionView)
        
        let metricsDictionary = ["sidePadding":15, "verticalPadding":15]
        let viewsDictionary = ["tagsTypeLabel":self.tagsTypeLabel, "tagsCollectionView":self.tagsCollectionView]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[tagsTypeLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[tagsTypeLabel]-5-[tagsCollectionView(44)]-verticalPadding-|", options: [NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(horizontalConstraints)
        self.contentView.addConstraints(verticalConstraints)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.tagsArray)
        return self.tagsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCollectionViewCell", forIndexPath: indexPath) as! TagCollectionViewCell
        cell.tagLabel.text = self.tagsArray[indexPath.item]
        return cell
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
