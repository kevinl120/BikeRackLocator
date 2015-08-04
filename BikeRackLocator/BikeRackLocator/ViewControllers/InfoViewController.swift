//
//  InfoViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/31/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

import Parse

class InfoViewController: UIViewController {
    
    var bikeRack: BikeRack!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        bikeRack.imageFile.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
            self.imageView.image = UIImage(data: data!)
        }
        self.titleLabel.text = bikeRack.title
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
