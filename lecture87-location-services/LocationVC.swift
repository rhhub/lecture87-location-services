//
//  SecondViewController.swift
//  lecture87-location-services
//
//  Created by Ryan Huebert on 1/27/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//


import UIKit
import MapKit

// Add NSLocationWhenInUseUsageDescription or NSLocationAlwaysInUseUsageDescription to plist, respect user build trust

class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000 // meters
    
    let locationManager = CLLocationManager()
    
    // Pretend download from server
    let addresses = [
        "10889 N De Anza Blvd, Cupertino, CA 95014",
        "20545 Valley Green Dr, Cupertino, CA 95014",
        "1 Infinite Loop, Cupertino, CA 95014"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        for add in addresses {
            getPlacemarkFromAddress(add)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
        
        CLGeocoder().geocodeAddressString(addresses[0]) { (placemarks, error) -> Void in
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    self.centerMapOnLocation(loc)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(loc)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // called when annotation dropped
        
        if annotation.isKindOfClass(BootcampAnnotation) {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.yellowColor()
            annoView.animatesDrop = true
            return annoView
            
        } else if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        return nil
    }
    
    func createAnnotationForLocation(location: CLLocation) {
        let bootcamp = BootcampAnnotation(coordinate: location.coordinate)
        map.addAnnotation(bootcamp)
    }
    
    func getPlacemarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForLocation(loc)
                }
            }
        }
    }
}
