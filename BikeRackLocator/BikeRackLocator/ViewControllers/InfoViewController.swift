//
//  InfoViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/31/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import Parse
import GoogleMaps

class InfoViewController: UIViewController {
    
    var bikeRack: BikeRack!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        bikeRack.imageFile.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
            self.imageView.image = UIImage(data: data!)
        }
        self.titleLabel.text = bikeRack.title
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)) {
            (let gmsReverseGeocodeResponse: GMSReverseGeocodeResponse!, let error: NSError!) -> Void in
            
            let gmsAddress: GMSAddress = gmsReverseGeocodeResponse.firstResult()
            
            self.addressLabel.text = "\(gmsAddress.thoroughfare)"

        }    
//                    println("\ncoordinate.latitude=\(gmsAddress.coordinate.latitude)")
//                    println("coordinate.longitude=\(gmsAddress.coordinate.longitude)")
//                    println("thoroughfare=\(gmsAddress.thoroughfare)")
//                    println("locality=\(gmsAddress.locality)")
//                    println("subLocality=\(gmsAddress.subLocality)")
//                    println("administrativeArea=\(gmsAddress.administrativeArea)")
//                    println("postalCode=\(gmsAddress.postalCode)")
//                    println("country=\(gmsAddress.country)")
//                    println("lines=\(gmsAddress.lines)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }


}
