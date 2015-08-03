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

class AddViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    var image: UIImage!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonPressed")), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonPressed")), animated: true)
        
        // Set up map
        mapView.camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 16)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // Add marker where bike rack location is
        var marker = GMSMarker()
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.position = CLLocationCoordinate2DMake(latitude!, longitude!)
        marker.map = mapView
        
        // Set up location text field
        locationTextField.text = "\(latitude), \(longitude)"
    }

    @IBAction func addImage(sender: AnyObject) {
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.image = image!
        })
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
                mapViewController.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.popToViewController(viewController as! UIViewController, animated: true)
                break
            }
        }
    }
    
    func saveButtonPressed() {
        let bikeRack = BikeRack()
        
        if titleTextField.text == "" {
            bikeRack.title = "Bike Rack"
        } else {
            bikeRack.title = titleTextField.text
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
    }
}
