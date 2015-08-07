//
//  InfoViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 8/7/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import GoogleMaps

class InfoViewController: UIViewController {

    var bikeRack: BikeRack!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityStateZipLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bikeRack.imageFile.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
            self.imageView.image = UIImage(data: data!)
        }
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(bikeRack.location.latitude, longitude: bikeRack.location.longitude, zoom: 16)
            var marker = GMSMarker()
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.position = CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)
            marker.map = mapView
        
        self.titleLabel.text = bikeRack.title
        
//        let geocoder = GMSGeocoder()
//        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)) {
//            (let gmsReverseGeocodeResponse: GMSReverseGeocodeResponse!, let error: NSError!) -> Void in
//
//            let gmsAddress: GMSAddress = gmsReverseGeocodeResponse.firstResult()
//            self.streetAddressLabel.text = "\(gmsAddress.thoroughfare)"
//            
//            self.cityStateZipLabel.text = "\(gmsAddress.thoroughfare), \(gmsAddress.locality), \(gmsAddress.administrativeArea) \(gmsAddress.postalCode)"
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
