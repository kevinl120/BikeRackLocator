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
    
    var uploadTask: UIBackgroundTaskIdentifier?
    
    @NSManaged var location: PFGeoPoint?
    @NSManaged var image: PFFile
    @NSManaged var title: String?
    
    func upload() {
        save()
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
