//
//  LocationsViewController.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/13/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Locations"
        
        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        let filterBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "filterBarButtonItemTapped:")
        self.navigationItem.rightBarButtonItem = filterBarButtonItem
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

}
