//
//  MapViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/22/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import SystemConfiguration
import GoogleMaps
import Parse

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpLocationManager()
        
        mapView.delegate = self
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("updateMap"), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMap() {
        // Set up map
        if hasUserLocation() {
            mapView.camera = GMSCameraPosition.cameraWithLatitude(locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude, zoom: 16)
            findBikeRacks()
        } else {
            mapView.camera = GMSCameraPosition.cameraWithLatitude(37.33233, longitude: -122.03121, zoom: 16)
        }
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // MARK: - Mechanics
    
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
        
        mapView.clear()
        
        var query = PFQuery(className: "BikeRack")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude), withinMiles: 0.5)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let bikeRacks = objects as? [PFObject] {
                    for bikeRack in bikeRacks {
                        let bikeRack = bikeRack as! BikeRack
                        var marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)
                        marker.infoWindowAnchor = CGPoint(x: 0.6, y: 0.2)
                        marker.map = self.mapView
                    }
                }
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    // MARK: - Connection
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return isReachable && !needsConnection
    }
    
    // MARK: - Location Update
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        var test = newLocation.distanceFromLocation(oldLocation)
        
        if oldLocation == nil || newLocation.distanceFromLocation(oldLocation) > 25 {
            updateMap()
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
    
    // MARK: - Google Maps
}


