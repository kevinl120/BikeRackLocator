//
//  InfoTableViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 8/13/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import Parse
import GoogleMaps
import MapKit

class InfoTableViewController: UITableViewController {

    var bikeRack: BikeRack!

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityStateZipLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        bikeRack.imageFile.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
            self.imageView.image = UIImage(data: data!)
        }
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(bikeRack.location.latitude, longitude: bikeRack.location.longitude, zoom: 16)
        var marker = GMSMarker()
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.position = CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)
        marker.map = mapView
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)) {
            (let gmsReverseGeocodeResponse: GMSReverseGeocodeResponse!, let error: NSError!) -> Void in
            
            let gmsAddress: GMSAddress = gmsReverseGeocodeResponse.firstResult()
            self.streetAddressLabel.text = "\(gmsAddress.thoroughfare)"
            
            self.cityStateZipLabel.text = "\(gmsAddress.locality), \(gmsAddress.administrativeArea) \(gmsAddress.postalCode)"
        }
        
//        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: bikeRack.location.latitude, longitude: bikeRack.location.longitude), completionHandler: {(placemarks, error) -> Void in
//            
//            if error != nil {
//                println("Reverse geocoder failed with error" + error.localizedDescription)
//                return
//            }
//            
//            if placemarks.count > 0 {
//                let pm = placemarks[0] as! CLPlacemark
//                self.streetAddressLabel.text = pm.thoroughfare
//                self.cityStateZipLabel.text = pm.locality + ", " + pm.administrativeArea + " " + pm.postalCode
//            } else {
//                println("Problem with the data received from geocoder")
//            }
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            // Map View height
            var aspectRatio: CGFloat = 1.0/3.0
            return UIScreen.mainScreen().bounds.size.height * aspectRatio
        case 1:
            return streetAddressLabel.bounds.height + cityStateZipLabel.bounds.height + 48
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                
                let alertController = UIAlertController(title: "Directions", message: "Which app do you want to use?", preferredStyle: .Alert)
                
                 // Adds cancel button
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                // Adds google maps option
                let googleMapsAction = UIAlertAction(title: "Google Maps", style: .Default) { (action) in
                    UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?daddr=\(bikeRack.location.latitude),\(bikeRack.location.longitude)&directionsmode=bicycling")!)
                }
                alertController.addAction(googleMapsAction)
                
                // Adds apple maps option
                let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .Default) { (action) in
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/maps?saddr=Current%20Location&daddr=\(self.bikeRack.location.latitude),\(self.bikeRack.location.longitude)")!)
                }
                alertController.addAction(appleMapsAction)
                
                // Show the alert controller
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/maps?saddr=Current%20Location&daddr=\(self.bikeRack.location.latitude),\(self.bikeRack.location.longitude)")!)
            }
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showFlags" {
            // create a new Note and hold on to it, to be able to save it later
            let flagTableViewController = segue.destinationViewController as! FlagTableViewController
            flagTableViewController.bikeRack = self.bikeRack
        }
    }


}
