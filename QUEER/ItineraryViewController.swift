//
//  ItineraryViewController.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/13/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class ItineraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableViewVC:UITableViewController!
    var itineraryFilter:String!
    var mainViewVC:MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Itinerary"
        
        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        self.tableViewVC = UITableViewController()
        self.tableViewVC.tableView = TPKeyboardAvoidingTableView(frame: self.view.frame)
        //        self.tableViewVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewVC.tableView.delegate = self
        self.tableViewVC.tableView.dataSource = self
        self.addChildViewController(self.tableViewVC)
        self.view.addSubview(self.tableViewVC.tableView)
        
        self.tableViewVC.refreshControl?.addTarget(self, action: "refreshed:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableViewVC.tableView.registerClass(LocationTableViewCell.self, forCellReuseIdentifier: "LocationTableViewCell")
        self.tableViewVC.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableViewVC.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableViewVC.tableView.estimatedRowHeight = 80

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeBarButtonItemTapped(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: {self.mainViewVC.loadLocationsWithStories("")})
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "value1")
        switch indexPath.row{
        case 0:
            cell.textLabel!.text = "Queer People of Color Stories"
        case 1:
            cell.textLabel!.text = "Trans Stories"
        case 2:
            cell.textLabel!.text = "Queer Youth Stories"
        default:
            print("default case")

        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.itineraryFilter = (self.tableViewVC.tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell).textLabel?.text
        
        self.dismissViewControllerAnimated(true, completion: {self.mainViewVC.loadLocationsWithStories(self.itineraryFilter)})
        
    }
    

}
