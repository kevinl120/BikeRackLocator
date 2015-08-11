//
//  BikeRack.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/23/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import Parse

class BikeRack: PFObject, PFSubclassing {
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    var image: UIImage?
    
    @NSManaged var location: PFGeoPoint
    @NSManaged var imageFile: PFFile
    @NSManaged var bikeRackTitle: String?
    @NSManaged var bikeRackDescription: String?
    
    func upload() {
        
        if let image = image {
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imageFile = PFFile(data: imageData)
            
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            self.imageFile = imageFile
        }
        
        saveInBackgroundWithBlock(nil)
    }
    
    // MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "BikeRack"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}
