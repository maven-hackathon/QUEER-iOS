//
//  LocationDetailViewController.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/13/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import Parse
import SafariServices
import MapKit
import Contacts

class LocationDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var location:PFObject!
    
    var tableViewVC:UITableViewController!
    var shareButton:UIBarButtonItem!
    
    var feedback:NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Location"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareButtonTapped:")
        //        self.shareButton.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.redColor()], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = self.shareButton
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.tableViewVC = UITableViewController()
        self.tableViewVC.tableView = TPKeyboardAvoidingTableView(frame: self.view.frame)
        self.tableViewVC.tableView.delegate = self
        self.tableViewVC.tableView.dataSource = self
        self.tableViewVC.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableViewVC.tableView.registerClass(LocationSummaryTableViewCell.self, forCellReuseIdentifier: "LocationSummaryTableViewCell")
        self.tableViewVC.tableView.registerClass(TagsCollectionViewTableViewCell.self, forCellReuseIdentifier: "TagsCollectionViewTableViewCell")
        self.tableViewVC.tableView.registerClass(TextBlockTableViewCell.self, forCellReuseIdentifier: "TextBlockTableViewCell")
        self.tableViewVC.tableView.registerClass(TextBlockWithIconTableViewCell.self, forCellReuseIdentifier: "TextBlockWithIconTableViewCell")
        self.addChildViewController(self.tableViewVC)
        
        self.view.addSubview(self.tableViewVC.tableView)
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationSummaryTableViewCell") as! LocationSummaryTableViewCell
            cell.nameLabel.text = self.location["name"] as? String
            cell.bioDescriptionLabel.text = self.location["summary"] as? String
            cell.profileImageView.sd_setImageWithURL(NSURL(string: ((self.location["profileSquare"] as! PFObject)["file"] as! PFFile).url!))
            cell.profileImageView.layer.borderWidth = 1
            cell.profileImageView.layer.borderColor = ColorDictionary.interfaceTypeColors["separatorGrey"]?.CGColor
            cell.profileImageView.layer.cornerRadius = 6
            return cell
        case 1:
                switch indexPath.row{
                case 0:
                    // Phone
                    let cell = tableView.dequeueReusableCellWithIdentifier("TextBlockWithIconTableViewCell") as! TextBlockWithIconTableViewCell
                    cell.headerLabel.text = "Phone"
                    cell.bodyLabel?.text = self.location["phoneNumber"] as? String
                    cell.iconImageView.image = UIImage(named: "phoneButtonIcon")
                    return cell
                case 1:
                    // Directions
                    let cell = tableView.dequeueReusableCellWithIdentifier("TextBlockWithIconTableViewCell") as! TextBlockWithIconTableViewCell
                    cell.headerLabel.text = "Directions"
                    let streeAddressString = (self.location["streetAddress"] as! String)
                    let cityString = (self.location["city"] as! String)
                    let stateString = (self.location["state"] as! String)
                    cell.iconImageView.image = UIImage(named: "directionsButtonIcon")
                    cell.bodyLabel?.text = "\(streeAddressString)\n\(cityString), \(stateString)"
                    return cell
                case 2:
                    // Website
                    let cell = tableView.dequeueReusableCellWithIdentifier("TextBlockWithIconTableViewCell") as! TextBlockWithIconTableViewCell
                    cell.headerLabel.text = "Website"
                    cell.iconImageView.image = UIImage(named: "webButtonIcon")
                    cell.bodyLabel?.text = self.location["url"] as? String
                    return cell
                case 3:
                    let cell = tableView.dequeueReusableCellWithIdentifier("TagsCollectionViewTableViewCell") as! TagsCollectionViewTableViewCell
                    
                    cell.tagsArray = self.location["tags"] as! [String]
                    cell.tagsTypeLabel.text = "Categories"
                    return cell
                case 4:
                    // Long Intro
                    let cell = tableView.dequeueReusableCellWithIdentifier("TextBlockTableViewCell") as! TextBlockTableViewCell
                    cell.headerLabel.text = "About"
                    cell.bodyLabel?.text = self.location["summary"] as? String
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                default:
                    return UITableViewCell()
                }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 180
        case 1:
            return 250
        default:
            return 0
        }
    }
    
    
    func shareButtonTapped(sender:UIBarButtonItem){
        print("share")
        let textToShare = "\(self.location["name"]!)."
        let phoneNumber = "Phone: \(self.location["phoneNumber"]!)."
        let website = NSURL(string: "\(self.location["url"]!)")!
        let objectsToShare = [textToShare, phoneNumber, website]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            print("summary case")
        case 1:
            switch indexPath.row{
            case 0:
                print("Phone")
                let phoneString = self.location["phoneNumber"] as! String
                let phoneURLString = "tel://\(phoneString)"
                UIApplication.sharedApplication().openURL(NSURL(string: phoneURLString)!)
            case 1:
                print("Directions")
                let resourceGeoPoint = self.location["latlon"] as! PFGeoPoint
                let streetAddress = self.location["streetAddress"] as! String
                let cityString = self.location["city"] as! String
                let stateString = self.location["state"] as! String
                let addressDictionary:[String:String] =
                [
                    CNPostalAddressStreetKey:streetAddress,
                    CNPostalAddressCityKey: cityString,
                    CNPostalAddressStateKey: stateString
                ]
                let place = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: resourceGeoPoint.latitude, longitude: resourceGeoPoint.longitude), addressDictionary: addressDictionary)
                let mapItem = MKMapItem(placemark: place)
                mapItem.name = self.location["name"] as? String
                mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
            case 2:
                // Website
                let webURL = self.location["url"] as! String
                let safariVC = SFSafariViewController(URL: NSURL(string: webURL)!)
                safariVC.view.tintColor = ColorDictionary.interfaceTypeColors["normal"]
                self.presentViewController(safariVC, animated: true, completion: nil)
            case 3:
                print("Members")
            case 4:
                // Similar Activities
                print("Related Groups")
            default:
                print("default case")
            }
        default:
            print("default case")
        }
        
    }
    
    func callButtonTapped(sender:UIButton){
        let phoneString = self.location["phoneNumber"] as! String
        let phoneURLString = "tel://\(phoneString)"
        UIApplication.sharedApplication().openURL(NSURL(string: phoneURLString)!)
    }
    
}
