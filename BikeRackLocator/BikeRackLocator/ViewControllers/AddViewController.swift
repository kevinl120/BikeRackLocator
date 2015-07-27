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


class AddViewController: UIViewController {
    
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up navigation bar
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonPressed")), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonPressed")), animated: true)
        
        // Set up map
        var camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 16)
        var mapView = GMSMapView.mapWithFrame(CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 0.5), camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.view.addSubview(mapView)
        
        // Add marker where bike rack location is
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude!, longitude!)
        marker.map = mapView
        
        // Set up location text field
        locationTextField.text = "\(latitude), \(longitude)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    func cancelButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveButtonPressed() {
        let bikeRack = BikeRack()
        bikeRack.title = "Test"
        bikeRack.location = PFGeoPoint(latitude: latitude, longitude: longitude)
        bikeRack.upload()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println("Test")
    }
    

}
