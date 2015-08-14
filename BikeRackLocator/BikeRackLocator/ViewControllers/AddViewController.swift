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

class AddViewController: UIViewController, UITextFieldDelegate, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addedImage: UIImageView!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityStateZipTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var latitude: Double!
    var longitude: Double!
    
    var photoTakingHelper: PhotoTakingHelper?
    
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
        
        // Set up text fields
        descriptionTextField.delegate = self
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(latitude, longitude)) {
            (let gmsReverseGeocodeResponse: GMSReverseGeocodeResponse!, let error: NSError!) -> Void in
            
            let gmsAddress: GMSAddress = gmsReverseGeocodeResponse.firstResult()
            
            self.streetAddressTextField.text = "\(gmsAddress.thoroughfare)"
            self.cityStateZipTextField.text = "\(gmsAddress.locality), \(gmsAddress.administrativeArea) \(gmsAddress.postalCode)"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up keyboard to not block text fields
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unregister keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(true)
        } else if (self.view.frame.origin.y < 0) {
            setViewMovedUp(false)
        }
    }
    
    func keyboardWillHide() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(true)
        } else if (self.view.frame.origin.y < 0) {
            setViewMovedUp(false)
        }
    }
    
    func setViewMovedUp(movedUp: Bool) {
        
        let keyboardOffset: CGFloat = 80.0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        
        if movedUp {
            rect.origin.y -= keyboardOffset
            rect.size.height += keyboardOffset
        } else {
            rect.origin.y += keyboardOffset
            rect.size.height -= keyboardOffset
        }
        self.view.frame = rect
        
        UIView.commitAnimations()
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
    
    @IBAction func addImageButtonPressed(sender: AnyObject) {
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.addedImage.image = image
            self.addImageButton.hidden = true
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
                self.navigationController?.popToViewController(viewController as! UIViewController, animated: true)
                break
            }
        }
    }
    
    func saveButtonPressed() {
        println("savePressed")
        
        let bikeRack = BikeRack()
        
//        var nonExistentFlag = Flag()
//        nonExistentFlag.flagDescription = "Bike Rack does not exist"
//        nonExistentFlag.votes = 0
//        nonExistentFlag.upload()
//        bikeRack.flags.addObject(nonExistentFlag)
//        
//        var inaccessibleFlag = Flag()
//        inaccessibleFlag.flagDescription = "Inaccessible bike rack"
//        inaccessibleFlag.votes = 0
//        inaccessibleFlag.upload()
//        bikeRack.flags.addObject(inaccessibleFlag)
//        
//        var duplicateFlag = Flag()
//        duplicateFlag.flagDescription = "Duplicate Bike Rack"
//        duplicateFlag.votes = 0
//        duplicateFlag.upload()
//        bikeRack.flags.addObject(duplicateFlag)

        
        if descriptionTextField.text == "" {
            bikeRack.bikeRackDescription = "Bike Rack"
        } else {
            bikeRack.bikeRackDescription = descriptionTextField.text
        }

        bikeRack.location = PFGeoPoint(latitude: latitude, longitude: longitude)
        
        if let image = addedImage.image {
            bikeRack.image = image
        }

        bikeRack.upload()
        
        cancelButtonPressed()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var maxTextCharacters = 100
        
        switch textField {
        case descriptionTextField:
            maxTextCharacters = 50
        default:
            break;
        }
        
        if (range.length + range.location > count(textField.text)) {
            return false;
        }
        
        let newLength = count(textField.text) + count(string) - range.length
        
        if newLength > maxTextCharacters {
            if count(string) > 1 {
                var alert = UIAlertView(title: "Oops!", message: "That message is too long. Keep it under \(maxTextCharacters) characters.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            return false
        } else {
            return true
        }
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

