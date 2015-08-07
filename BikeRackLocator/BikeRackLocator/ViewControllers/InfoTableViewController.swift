//
//  InfoTableViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 8/6/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import Parse
import GoogleMaps

class InfoTableViewController: UITableViewController {

    var bikeRack: BikeRack!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //        bikeRack.imageFile.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
        //            self.imageView.image = UIImage(data: data!)
        //        }
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(bikeRack.location.latitude, longitude: bikeRack.location.longitude, zoom: 16)
        var marker = GMSMarker()
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.position = CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)
        marker.map = mapView
        
        self.titleLabel.text = bikeRack.title
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(bikeRack.location.latitude, bikeRack.location.longitude)) {
            (let gmsReverseGeocodeResponse: GMSReverseGeocodeResponse!, let error: NSError!) -> Void in
            
            let gmsAddress: GMSAddress = gmsReverseGeocodeResponse.firstResult()
            self.addressLabel.text = "\(gmsAddress.thoroughfare), \(gmsAddress.locality), \(gmsAddress.administrativeArea), \(gmsAddress.postalCode)"
        }
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

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
