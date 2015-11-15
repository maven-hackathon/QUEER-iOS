//
//  MainViewController.swift
//  QUEER
//
//  Created by Chun-Wei Chen on 11/13/15.
//  Copyright © 2015 Eddie Chen. All rights reserved.
//

import UIKit
import MapKit
import TPKeyboardAvoiding
import Parse
import SDWebImage

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {

    var mapView:MKMapView!
    var cardsCollectionView:TPKeyboardAvoidingCollectionView!
    
    let bottomHeight:CGFloat = 10
    let sidePadding:CGFloat = 10
    var cellWidth:CGFloat!
    var cellHeight:CGFloat!
    var playing:Bool = false
    
    var actionsCanvasView:UIVisualEffectView!
    var playPauseButton:UIButton!
    var nextStoryButton:UIButton!
    var previousStoryButton:UIButton!

    var currentIndex = 0
    var currentAnnotation:MKPointAnnotation!
    
    var locationsWithStories:NSMutableArray = NSMutableArray()
    var annotations:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cellWidth = UIScreen.mainScreen().bounds.width - self.sidePadding * 2
        self.cellHeight = self.cellWidth
        self.navigationItem.title = "QUEER"
        let itineraryBarButtonItem = UIBarButtonItem(image: UIImage(named: "itineraryButton"), style: UIBarButtonItemStyle.Plain, target: self, action: "itineraryBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = itineraryBarButtonItem
        
        let locationsBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "locationsBarButtonItemTapped:")
        self.navigationItem.rightBarButtonItem = locationsBarButtonItem
        
        self.mapView = MKMapView(frame: CGRectZero)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, self.cellHeight)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.cardsCollectionView = TPKeyboardAvoidingCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.cardsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.cardsCollectionView.delegate = self
        self.cardsCollectionView.dataSource = self
        self.cardsCollectionView.pagingEnabled = true
        self.cardsCollectionView.backgroundColor = UIColor.clearColor()
        self.cardsCollectionView.alwaysBounceHorizontal = true
        self.cardsCollectionView.showsHorizontalScrollIndicator = false
        self.cardsCollectionView.registerClass(CardsCollectionViewCell.self, forCellWithReuseIdentifier: "CardsCollectionViewCell")
        self.view.addSubview(self.cardsCollectionView)
        
        self.actionsCanvasView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        self.actionsCanvasView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.actionsCanvasView)
        
        self.playPauseButton = UIButton(frame: CGRectZero)
        self.playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        if (!self.playing){
            self.playPauseButton.setImage(UIImage(named: "playPauseButton"), forState: UIControlState.Normal)
        }
        else{
            self.playPauseButton.setImage(UIImage(named: "pauseButton"), forState: UIControlState.Normal)
        }
        self.playPauseButton.addTarget(self, action: "playPauseButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.actionsCanvasView.addSubview(self.playPauseButton)
        
        self.nextStoryButton = UIButton(frame: CGRectZero)
        self.nextStoryButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextStoryButton.setImage(UIImage(named: "nextStoryButton"), forState: UIControlState.Normal)
        self.nextStoryButton.addTarget(self, action: "nextStoryButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.nextStoryButton.enabled = false
        self.actionsCanvasView.addSubview(self.nextStoryButton)
        
        self.previousStoryButton = UIButton(frame: CGRectZero)
        self.previousStoryButton.translatesAutoresizingMaskIntoConstraints = false
        self.previousStoryButton.setImage(UIImage(named: "previousStoryButton"), forState: UIControlState.Normal)
        self.previousStoryButton.addTarget(self, action: "previousStoryButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.previousStoryButton.enabled = false
        self.actionsCanvasView.addSubview(self.previousStoryButton)

        let viewsDictionary = ["mapView":self.mapView, "cardsCollectionView":self.cardsCollectionView, "actionsCanvasView":self.actionsCanvasView]
        let metricsDictionary = ["sidePadding":self.sidePadding,"bottomPadding":self.bottomHeight, "cardsCollectionViewHeight":self.cellHeight]
        
        let mapViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        let mapViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        
        self.view.addConstraints(mapViewHorizontalConstraints)
        self.view.addConstraints(mapViewVerticalConstraints)
        
        let cardsCollectionViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[cardsCollectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        let cardsCollectionViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[cardsCollectionView(cardsCollectionViewHeight)]-15-[actionsCanvasView(50)]|", options: [NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        self.view.addConstraints(cardsCollectionViewHorizontalConstraints)
        self.view.addConstraints(cardsCollectionViewVerticalConstraints)
        
        let actionsCanvasViewViewsDictionary = ["playPauseButton":self.playPauseButton, "nextStoryButton":self.nextStoryButton, "previousStoryButton":self.previousStoryButton]
        let actionsCanvasViewMetricsDictionary = ["verticalPadding":7.5]
        
        let playPauseButtonCenterXConstraint = NSLayoutConstraint(item: self.playPauseButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.actionsCanvasView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.actionsCanvasView.addConstraint(playPauseButtonCenterXConstraint)
        
        let actionsCanvasViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-12.5-[previousStoryButton(50)]->=0-[playPauseButton(50)]->=0-[nextStoryButton(50)]-12.5-|", options: [NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: actionsCanvasViewMetricsDictionary, views: actionsCanvasViewViewsDictionary)
        
        let actionsCanvasViewVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[playPauseButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: actionsCanvasViewMetricsDictionary, views: actionsCanvasViewViewsDictionary)

        self.actionsCanvasView.addConstraints(actionsCanvasViewHConstraints)
        self.actionsCanvasView.addConstraints(actionsCanvasViewVConstraints)
        
        self.loadLocationsWithStories("")
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItinerary"{
            let destinationNC = segue.destinationViewController as! UINavigationController
            let destinationVC = destinationNC.childViewControllers[0] as! ItineraryViewController
            destinationVC.mainViewVC = self
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CardsCollectionViewCell", forIndexPath: indexPath) as! CardsCollectionViewCell
        cell.backgroundColor = UIColor.clearColor()
        let locationWithStories = self.locationsWithStories[indexPath.item] as! PFObject
        if (locationWithStories["featuredImage"] != nil){
        let locationFeaturedImageMediaAsset = locationWithStories["featuredImage"] as! PFObject
            cell.backgroundImageView.sd_setImageWithURL(NSURL(string: (locationFeaturedImageMediaAsset["file"] as! PFFile).url!))
        }
        else{
            cell.backgroundImageView.image = UIImage(named: "backgroundImagePlaceholder")
        }
        cell.locationNameLabel.text = locationWithStories["name"] as? String
        cell.locationSummaryLabel.text = locationWithStories["summary"] as? String
        cell.readMoreButton.addTarget(self, action: "readMoreButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.locationsWithStories.count
    }
    
    func readMoreButtonTapped(sender:UIButton){
        let location = self.locationsWithStories[self.currentIndex]
        let locationDetailVC = LocationDetailViewController()
        locationDetailVC.location = location as! PFObject
        self.navigationController?.pushViewController(locationDetailVC, animated: true)
    }
    
    func loadLocationsWithStories(itineraryType:String){
        let locationsWithStoriesQuery = PFQuery(className: "Location")
//        locationsWithStoriesQuery.whereKey("content", notEqualTo: NSNull())
        locationsWithStoriesQuery.includeKey("featuredImage")
        locationsWithStoriesQuery.includeKey("profileSquare")
        if itineraryType != ""{
            locationsWithStoriesQuery.whereKey("tags", equalTo: itineraryType)
        }
        locationsWithStoriesQuery.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            if (error == nil){
                self.locationsWithStories = NSMutableArray(array: objects!)
                self.updateControlsWithCurrentIndex()
                self.cardsCollectionView.reloadSections(NSIndexSet(index: 0))
                let tempAnnotations:NSMutableArray = NSMutableArray()
                for location in self.locationsWithStories{
                    let annotation = MKPointAnnotation()
                    let locationGeoPoint = location["latlon"] as! PFGeoPoint
                    annotation.coordinate = CLLocationCoordinate2D(latitude: locationGeoPoint.latitude, longitude: locationGeoPoint.longitude)
                    annotation.title = location["name"] as? String
                    tempAnnotations.addObject(annotation)
                }
                self.mapView.removeAnnotations(self.annotations as! [MKPointAnnotation])
                self.annotations = tempAnnotations
                self.mapView.addAnnotations(self.annotations as! [MKPointAnnotation])
                self.cardsCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                self.zoomToPinOfCurrentLocation()
            }
            else{
                print(error)
            }
        })
    }
    
    func previousStoryButtonTapped(sender:UIButton){
        if self.currentIndex - 1 >= 0{
            self.cardsCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.currentIndex - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            self.currentIndex--
            print(self.currentIndex)
            self.updateControlsWithCurrentIndex()
            self.zoomToPinOfCurrentLocation()
        }
        else{
            print("end of itinerary")
            sender.enabled = false
        }
    }
    
    func nextStoryButtonTapped(sender:UIButton){
        if self.currentIndex + 1 < self.locationsWithStories.count{
            self.cardsCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.currentIndex + 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            self.currentIndex++
            print(self.currentIndex)
            self.updateControlsWithCurrentIndex()
            self.zoomToPinOfCurrentLocation()
        }
        else{
            print("end of itinerary")
            sender.enabled = false
        }
    }
    
    func playPauseButtonTapped(sender:UIButton){
        self.playing = !self.playing
        if (!self.playing){
            self.playPauseButton.setImage(UIImage(named: "playPauseButton"), forState: UIControlState.Normal)
        }
        else{
            self.playPauseButton.setImage(UIImage(named: "pauseButton"), forState: UIControlState.Normal)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView == self.cardsCollectionView){
            self.currentIndex = Int(self.cardsCollectionView.contentOffset.x / self.cardsCollectionView.frame.size.width)
            self.updateControlsWithCurrentIndex()
            self.zoomToPinOfCurrentLocation()
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let name = view.annotation!.title!
        var index = 0
        for location in self.locationsWithStories{
            if location["name"] as? String == name{
                self.cardsCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            }
            index++
        }
    }
    func updateControlsWithCurrentIndex(){
        if self.currentIndex - 1 < 0{
            self.previousStoryButton.enabled = false
        }
        if self.currentIndex + 1 < self.locationsWithStories.count{
            self.nextStoryButton.enabled = true
        }
        if self.currentIndex + 1 >= self.locationsWithStories.count{
            self.nextStoryButton.enabled = false
        }
        if self.currentIndex - 1 >= 0{
            self.previousStoryButton.enabled = true
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        else{
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
            pinView.animatesDrop = true
            pinView.pinTintColor = UIColor.redColor()
            pinView.enabled = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
            return pinView
        }
    }

    
    func zoomToPinOfCurrentLocation(){
        let currentLocationWithStories = self.locationsWithStories[self.currentIndex]["latlon"] as! PFGeoPoint
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: currentLocationWithStories.latitude * 0.99992, longitude: currentLocationWithStories.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
//        if (self.currentAnnotation != nil){
//            self.mapView.removeAnnotation(self.currentAnnotation)
//        }
        self.mapView.setRegion(region, animated: true)
        self.mapView.selectAnnotation(self.annotations[self.currentIndex] as! MKAnnotation, animated: true)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: currentLocationWithStories.latitude, longitude: currentLocationWithStories.longitude)
//        annotation.title = self.locationsWithStories[self.currentIndex]["name"] as? String
//        self.currentAnnotation = annotation
//        self.mapView.addAnnotation(self.currentAnnotation)
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let name = view.annotation!.title!
        for location in self.locationsWithStories{
            if location["name"] as? String == name{
                let locationDetailVC = LocationDetailViewController()
                locationDetailVC.location = location as! PFObject
                self.navigationController?.pushViewController(locationDetailVC, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itineraryBarButtonItemTapped(sender:UIBarButtonItem){
        print("itineraryBarButtonItemTapped")
        self.performSegueWithIdentifier("showItinerary", sender: self)
    }
    
    func locationsBarButtonItemTapped(sender:UIBarButtonItem){
        print("locationsBarButtonItemTapped")
        self.performSegueWithIdentifier("showLocations", sender: self)
    }
    
}
