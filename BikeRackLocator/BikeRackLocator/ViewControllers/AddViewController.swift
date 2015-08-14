//
//  AddViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/22/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import GoogleMaps
import Parse

class AddViewController: UIViewController, AddDataTableViewControllerProtocol, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    var latitude: Double!
    var longitude: Double!
    var bikeRackTitle: String!
    var bikeRackDescription: String!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up navigation bar
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonPressed")), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonPressed")), animated: true)
        
        drawDisplay()
        
        // Set up map
        mapView.camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 17)
        
        // Add marker where bike rack location is
        var marker = GMSMarker()
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.position = CLLocationCoordinate2DMake(latitude!, longitude!)
        marker.map = mapView
        
    }

    func drawDisplay() {
        
        // Edit map view display
        mapView.layer.cornerRadius = 10.0
        mapView.clipsToBounds = true;
        //        mapView.padding = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        //        var shadowPath = UIBezierPath(roundedRect: mapView.bounds, cornerRadius: 20.0)
        //        mapView.layer.masksToBounds = false
        //        mapView.layer.shadowColor = UIColor.blackColor().CGColor
        //        mapView.layer.shadowOffset = CGSizeMake(5.0, 5.0)
        //        mapView.layer.shadowOpacity = 1.0
        //        mapView.layer.shadowRadius = 1.0
        //        mapView.layer.shadowPath = shadowPath.CGPath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    func cancelButtonPressed() {
        for viewController in self.navigationController!.viewControllers as Array {
            if viewController.isKindOfClass(MapViewController) {
                var mapViewController = viewController as! MapViewController
                mapViewController.updateMap()
                self.navigationController?.popToViewController(viewController as! UIViewController, animated: true)
                break
            }
        }
    }
    
    func saveButtonPressed() {
        println("savePressed")
        
        let bikeRack = BikeRack()
        
        var nonExistentFlag = Flag()
        nonExistentFlag.flagDescription = "Bike Rack does not exist"
        nonExistentFlag.votes = 0
        nonExistentFlag.upload()
        bikeRack.flags.addObject(nonExistentFlag)
        
        var inaccessibleFlag = Flag()
        inaccessibleFlag.flagDescription = "Inaccessible bike rack"
        inaccessibleFlag.votes = 0
        inaccessibleFlag.upload()
        bikeRack.flags.addObject(inaccessibleFlag)
        
        var duplicateFlag = Flag()
        duplicateFlag.flagDescription = "Duplicate Bike Rack"
        duplicateFlag.votes = 0
        duplicateFlag.upload()
        bikeRack.flags.addObject(duplicateFlag)
        
        if let bikeRackTitle = bikeRackTitle {
            bikeRack.bikeRackTitle = bikeRackTitle
        } else {
            bikeRack.bikeRackTitle = "Bike Rack"
        }
    
        bikeRack.location = PFGeoPoint(latitude: latitude, longitude: longitude)
        
        if let image = image {
            bikeRack.image = image
        }

        bikeRack.upload()
        
        cancelButtonPressed()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDataEntry" {
            // create a new Note and hold on to it, to be able to save it later
            let addDataTableViewController = segue.destinationViewController as! AddDataTableViewController
            addDataTableViewController.latitude = self.latitude
            addDataTableViewController.longitude = self.longitude
            addDataTableViewController.delegate = self;
        }
    }
}

protocol AddDataTableViewControllerProtocol {
    var bikeRackTitle: String! {get set}
    var bikeRackDescription: String! {get set}
    var image: UIImage! {get set}
}


