//
//  ItineraryViewController.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/13/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit

class ItineraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Itinerary"
        
        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        let confirmBarButtonItem = UIBarButtonItem(title: "Confirm", style: UIBarButtonItemStyle.Plain, target: self, action: "confirmBarButtonItemTapped:")
        self.navigationItem.rightBarButtonItem = confirmBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeBarButtonItemTapped(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirmBarButtonItemTapped(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
