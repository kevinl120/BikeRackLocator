//
//  AddDataTableViewController.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 8/10/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

class AddDataTableViewController: UITableViewController, UITextFieldDelegate {
    
    var delegate: AddDataTableViewControllerProtocol!
    
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet var dataEntryTableView: UITableView!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        dataEntryTableView.allowsSelection = false
        // dataEntryTableView.tableHeaderView = UIView(frame: CGRectZero)
        dataEntryTableView.tableFooterView = UIView(frame: CGRectZero)
        // dataEntryTableView.contentInset = UIEdgeInsetsZero
        // self.automaticallyAdjustsScrollViewInsets = false
        
//        if let tableViewWrapperView = dataEntryTableView.subviews[0] as? UIView {
//            tableViewWrapperView.frame = dataEntryTableView.frame
//        }
    
        
//        for subView in dataEntryTableView.subviews {
//            if NSStringFromClass(subView)
//        }

        
        
        
        // Set up text fields
        locationTextField.text = "\(latitude), \(longitude)"
        locationTextField.enabled = false
        //locationTextField.backgroundColor = UIColor.lightGrayColor()
        
        titleTextField.delegate = self
        descriptionTextField.delegate = self
    }

    @IBAction func addImage(sender: AnyObject) {
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.delegate.imageFile = image
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var maxTextCharacters = 0
        
        switch textField {
        case titleTextField:
            maxTextCharacters = 10
        case descriptionTextField:
            maxTextCharacters = 15
        default:
            break;
        }
        
        if (range.length + range.location > count(textField.text) )
        {
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

//        switch textField {
//        case titleTextField:
//            if (titleTextField.text.length - range.length + text.length > maxLength) {
        
//                if (text.length > 1) { // only show popup if cut-and-pasting:
//                    var message = "That description is too long. Keep it under \(maxLength) characters.";
//                    var alert = [[UIAlertView alloc] initWithTitle:"Oops!"
//                    message:message
//                    delegate:nil
//                    cancelButtonTitle:@"OK"
//                    otherButtonTitles:nil];
//                    [alert show];
//                }
//                return false;
//            }
//        }
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */

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
