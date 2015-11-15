//
//  LocationsViewController.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/13/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import Parse

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locations = NSMutableArray()
    var tableViewVC:UITableViewController!
    var segmentedControl = UISegmentedControl(items: ["Gender-Neutral Bathroom","Safe Space"])
    var refreshControl:UIRefreshControl!
    var filterString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Find"
        
        let closeBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeBarButtonIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "closeBarButtonItemTapped:")

        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        let filterBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "filterBarButtonItemTapped:")
        self.navigationItem.rightBarButtonItem = filterBarButtonItem
        
        self.tableViewVC = UITableViewController()
        self.tableViewVC.tableView = TPKeyboardAvoidingTableView(frame: self.view.frame)
        //        self.tableViewVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewVC.tableView.delegate = self
        self.tableViewVC.tableView.dataSource = self
        self.addChildViewController(self.tableViewVC)
        self.view.addSubview(self.tableViewVC.tableView)

        self.refreshControl = UIRefreshControl()
        self.tableViewVC.refreshControl = self.refreshControl
        self.tableViewVC.refreshControl?.addTarget(self, action: "refreshed:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableViewVC.tableView.registerClass(LocationTableViewCell.self, forCellReuseIdentifier: "LocationTableViewCell")
        self.tableViewVC.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableViewVC.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableViewVC.tableView.estimatedRowHeight = 80

        self.loadLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeBarButtonItemTapped(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func filterBarButtonItemTapped(sender:UIBarButtonItem){
        print("filterBarButtonItemTapped")
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationTableViewCell") as! LocationTableViewCell
            cell.nameLabel.text = self.locations[indexPath.row]["name"] as? String
            var tagsString = ""
            let tagsArray = self.locations[indexPath.row]["tags"] as! [String]
            for tag in tagsArray{
                tagsString += tag
                if tagsArray.indexOf(tag) != tagsArray.count - 1{
                    tagsString += ", "
                }
            }
            cell.tagsLabel.text = tagsString
            cell.profileImageView.layer.borderColor = ColorDictionary.interfaceTypeColors["separatorGrey"]?.CGColor
            cell.profileImageView.layer.borderWidth = 1
            cell.profileImageView.sd_setImageWithURL(NSURL(string:((self.locations[indexPath.row]["profileSquare"] as! PFObject)["file"] as! PFFile).url!))
            cell.descriptionLabel.text = self.locations[indexPath.row]["description"] as? String
            return cell
    }
    
    //    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    //        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
    //        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    //        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
    //        mapView.setRegion(region, animated: true)
    //    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count    
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let segmentedControlBackgroundView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        segmentedControlBackgroundView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.segmentedControl.frame = CGRectZero
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControl.tintColor = ColorDictionary.interfaceTypeColors["normal"]
        self.segmentedControl.addTarget(self, action: "segmentedControlTapped:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControlBackgroundView.addSubview(self.segmentedControl)
        
        let separatorView = UIView(frame: CGRectZero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = ColorDictionary.interfaceTypeColors["borderGrey"]
        segmentedControlBackgroundView.addSubview(separatorView)
        
        let metricsDictionary = ["sidePadding":7.5,"verticalPadding":7.5]
        let viewsDictionary = ["segmentedControl":self.segmentedControl, "separatorView":separatorView]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[segmentedControl]-sidePadding-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        segmentedControlBackgroundView.addConstraints(horizontalConstraints)
        
        let horizontalConstraintsForSeparator = NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        segmentedControlBackgroundView.addConstraints(horizontalConstraintsForSeparator)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[segmentedControl(28)]-verticalPadding-[separatorView(1)]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: metricsDictionary, views: viewsDictionary)
        segmentedControlBackgroundView.addConstraints(verticalConstraints)
        
        return segmentedControlBackgroundView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func refreshed(sender:UIRefreshControl){
        sender.beginRefreshing()
        self.loadLocations()
    }
    
    func loadLocations(){
        let locationsQuery = PFQuery(className: "Location")
        if self.filterString != nil{
            locationsQuery.whereKey("tags", equalTo: self.filterString)
        }
        locationsQuery.includeKey("featuredImage")
        locationsQuery.includeKey("profileSquare")
        locationsQuery.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            if (error == nil){
                self.locations = NSMutableArray(array: objects!)
                self.refreshControl.endRefreshing()
                let numRowToDelete:Int = self.tableViewVC.tableView.numberOfRowsInSection(0)
                let numRowToInsert:Int = objects!.count
                
                var indexPathsToInsert:[NSIndexPath] = []
                for (var i = 0; i < numRowToInsert; i++) {
                    indexPathsToInsert.append(NSIndexPath(forRow: i, inSection: 0))
                }
                
                var indexPathsToDelete:[NSIndexPath] = []
                for (var i = 0; i < numRowToDelete; i++) {
                    indexPathsToDelete.append(NSIndexPath(forRow: i, inSection: 0))
                }
                self.tableViewVC.tableView.beginUpdates()
                self.tableViewVC.tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableViewVC.tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableViewVC.tableView.endUpdates()

            }
            else{
                print(error)
            }
        })

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = self.locations[indexPath.row]
        let locationDetailVC = LocationDetailViewController()
        locationDetailVC.location = location as! PFObject
        self.navigationController?.pushViewController(locationDetailVC, animated: true)

    }
    
    func segmentedControlTapped(sender:UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            self.filterString = "Gender-Neutral Bathroom"
        case 1:
            self.filterString = "Safe Space"
        default:
            print("default case")
        }
        self.loadLocations()
    }

}
