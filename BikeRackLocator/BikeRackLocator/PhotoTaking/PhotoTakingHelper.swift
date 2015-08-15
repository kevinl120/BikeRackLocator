//
//  PhotoTakingHelper.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 7/27/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    // View controller on which AlertViewController and UIImagePickerController are presented
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    // Presents dialog that allows user to choose between camera and photo library
    func showPhotoSourceSelection() {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        // Adds cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        
        // Add choice of selecting photo from library
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        
        // Show the alert controller
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        //imagePickerController!.allowsEditing = true
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        viewController.dismissViewControllerAnimated(false, completion: nil)
        callback(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

