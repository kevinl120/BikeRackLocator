//
//  Flag.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 8/11/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import Parse

class Flag: PFObject, PFSubclassing {
    
    @NSManaged var flagDescription: String
    @NSManaged var votes: NSNumber
    @NSManaged var bikeRack: BikeRack
    
    func upload() {
        saveInBackgroundWithBlock(nil)
    }
    
    // MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "Flag"
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
