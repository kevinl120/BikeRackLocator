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
    @IBOutlet weak var addBikeRackButton: UIButton!
    
    var calloutView = SMCalloutView()
    var emptyCalloutView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let CalloutYOffset: CGFloat = 40.0
    
    var bikeRacksFound: [BikeRack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpLocationManager()
        
        setUpCalloutViews()
        
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 50.0, right: 0.0)
        
        addBikeRackButton.layer.cornerRadius = 20.0
        
//        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("updateMap")), animated: true)
        
        
        //var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("updateMap"), userInfo: nil, repeats: false)
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
        }
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
            
            let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (alertAction) in
                
                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
                {
                    UIApplication.sharedApplication().openURL(appSettings)
                }
            }
            alertController.addAction(settingsAction)
            
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
        
        if isConnectedToNetwork() {
            var query = PFQuery(className: "BikeRack")
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude), withinMiles: 0.5)
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let bikeRacks = objects as? [PFObject] {
                        for bikeRack in bikeRacks {
                            let bikeRack = bikeRack as! BikeRack
                            
                            self.bikeRacksFound.append(bikeRack)
                            
                            var marker = GMSMarker()
                            marker.position = CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)
                            marker.title = bikeRack.title
                            marker.map = self.mapView
                            marker.icon = bikeRack.image
                            marker.snippet = bikeRack.objectId
                        }
                    }
                } else {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        } else {
            connectionError()
        }
    }
    
    // MARK: - Callout Views
    
    func setUpCalloutViews() {
        var button: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        button.addTarget(self, action: Selector("calloutButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        
        calloutView.rightAccessoryView = button as UIView
    }
    
    func calloutButtonTapped() {
        self.performSegueWithIdentifier("showBikeRackInfo", sender: nil)
    }
    
    // MARK: - Connection
    
    func isConnectedToNetwork() -> Bool {
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
    
    func connectionError() {
        
        if !self.navigationController!.visibleViewController.isKindOfClass(UIAlertController) {
            let alertController = UIAlertController(title: "You're not connected to the internet", message: "Check your connection and try again", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Location Update
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        if oldLocation == nil {
            updateMap()
        }
        
        if newLocation.distanceFromLocation(oldLocation) > 25 {
            findBikeRacks()
        }
    }
    
    // MARK: - Google Maps
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        
        var anchor = marker.position
        
        var point = mapView.projection.pointForCoordinate(anchor)
        
        calloutView.title = marker.title
        calloutView.calloutOffset = CGPoint(x: 0, y: -CalloutYOffset)
        calloutView.hidden = false
        
        var calloutRect = CGRectZero
        calloutRect.origin = point
        calloutRect.size = CGSizeZero
        
        calloutView.presentCalloutFromRect(calloutRect, inView: mapView, constrainedToView: mapView, animated: true)
        
        return self.emptyCalloutView
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        if mapView.selectedMarker != nil && calloutView.hidden == false {
            var anchor = mapView.selectedMarker.position
            var arrowPt = calloutView.backgroundView.arrowPoint
            var pt = mapView.projection.pointForCoordinate(anchor)
            
            pt.x -= arrowPt.x
            pt.y -= arrowPt.y + CalloutYOffset
            
            calloutView.frame = CGRect(origin: pt, size: calloutView.frame.size)
        } else {
            calloutView.hidden = true
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.calloutView.hidden = true
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return hasUserLocation()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destinationViewController.isKindOfClass(AddViewController) {
            var addViewController = segue.destinationViewController as! AddViewController
            
            addViewController.latitude = (locationManager.location.coordinate.latitude.description as NSString).doubleValue
            addViewController.longitude = (locationManager.location.coordinate.longitude.description as NSString).doubleValue
        } else {
            var infoViewController = segue.destinationViewController as! InfoViewController
            
            var counter = 0
            
            while bikeRacksFound[counter].objectId != mapView.selectedMarker.snippet {
                counter++
            }
            
            infoViewController.bikeRack = bikeRacksFound[counter]
        }
    }
    
}


