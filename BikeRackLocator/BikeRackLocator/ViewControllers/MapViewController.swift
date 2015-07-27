//
//  MapViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/22/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import GoogleMaps
import Parse

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpLocationManager()
        
        // Set up map
        var camera: GMSCameraPosition!
        
        if hasUserLocation() {
            camera = GMSCameraPosition.cameraWithLatitude(locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude, zoom: 16)
        } else {
            camera = GMSCameraPosition.cameraWithLatitude(37.33233, longitude: -122.03121, zoom: 16)
        }
        
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        
        if hasUserLocation() {
            findBikeRacks()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location
    
    func setUpLocationManager() {
        // Update user's location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func hasUserLocation() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .Denied, .Restricted:
            let alertController = UIAlertController(title: nil, message: "Please enable location services", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
            
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            if let location = self.locationManager.location {
                return true
            } else {
                let alertController = UIAlertController(title: nil, message: "Could not find your location", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return false
            }
        default:
            return false
        }
    }
    
    func findBikeRacks() {
        var query = PFQuery(className: "BikeRack")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude), withinMiles: 0.5)
        let optionalBikeRackArray = query.findObjects()
        
        if let bikeRackArray = optionalBikeRackArray {
            for bikeRack in bikeRackArray {
                let bikeRack = bikeRack as! BikeRack
                var marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)
                marker.map = mapView
            }
        }
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return hasUserLocation()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var addViewController = segue.destinationViewController as! AddViewController
        
        addViewController.latitude = (locationManager.location.coordinate.latitude.description as NSString).doubleValue
        addViewController.longitude = (locationManager.location.coordinate.longitude.description as NSString).doubleValue
    }
}
