//
//  AppDelegate.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/21/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import Parse
import GoogleMaps
// import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set navbar font
        let navigationController = window!.rootViewController as! UINavigationController
        navigationController.navigationBar.titleTextAttributes = [NSFontAttributeName : (UIFont(name: "OpenSans", size: 17.0))!]
        
        // Set bar button font
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 17.0)!], forState: UIControlState.Normal)
        
        // Set up Parse SDK
        Parse.setApplicationId("xAypJzhkukQ9BFgpUZutJVPrfjZViddmxMIM9egt", clientKey: "mwHwaWQmhG559IjmAV7YniN1w2st7hykbUH5No9a")
        BikeRack.registerSubclass()
        Flag.registerSubclass()
        
        // Set up Google Maps
        GMSServices.provideAPIKey("AIzaSyAFfX1V2LILrFH2rV4vz-7yb2teagR4FC8")
        
        // Set up Mixpanel
//        Mixpanel.sharedInstanceWithToken("0e394683032a3e37aa492c6a6b515a26")
//        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
//        mixpanel.track("App launched")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

