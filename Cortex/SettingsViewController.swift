//
//  SettingsViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/19/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let dataRepo = DataRepository()
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var installDateLabel: UILabel!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    @IBOutlet weak var syncDataButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var holderView : UIView!
    var customView : AboutCortexView!
    
    let currEmail = "nil" //UserUtils.getCurrentUsername()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        profileImageButton.layer.cornerRadius = 10
        aboutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        sendFeedbackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        syncDataButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        deleteAccountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        //set existing data
        emailLabel.text = currEmail
    }
    
    //######################################### SYNC HELPERS ######################################################
    
    
    func displayErrorAlert() {
        let alert = UIAlertController(title: "Unexpected Error", message: "No session available to the server. Please trying restarting Cortex.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: {})
    }

    func pause() {
        self.view.alpha = 0.6
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func restore(){
        self.view.alpha = 1
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        let alert = UIAlertController(title: "Success", message: "Data has been synced", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    // ######################################## PROFILE PIC HELPER ########################################
    
    @IBAction func profilePicButtonPressed(sender: AnyObject) {
        imagePicker.editing = false
        imagePicker.delegate = self
        let optionsMenu = UIAlertController(title: nil, message: "Picture Options", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imagePicker.navigationBar.backgroundColor = UIColor(rgba: "#F6A242")
            self.imagePicker.navigationBar.tintColor = UIColor.darkGrayColor()
            self.imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGrayColor()]
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) { (alert) -> Void in
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            optionsMenu.addAction(cameraButton)
        } else {
            print("Camera not available")
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        }
        
        optionsMenu.addAction(libButton)
        optionsMenu.addAction(cancelButton)
        
        self.presentViewController(optionsMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileImageButton.setImage(photo, forState: .Normal)
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) { () -> Void in
            //let photoData = UIImageJPEGRepresentation(photo!, 1)
            
        }
    }

    // ######################################## ABOUT HELPER ########################################
    
    @IBAction func aboutButtonPressed(sender: AnyObject) {
        holderView = UIView(frame: self.view.frame)
        holderView.backgroundColor = UIColor.grayColor()
        holderView.alpha = 0.6
        self.view.addSubview(holderView)
        
        let screenWidth : CGFloat = self.view.frame.size.width
        let customViewWidth : CGFloat = screenWidth - 30
        let navigationBarY = self.navigationController?.navigationBar.frame.origin.y
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        let customViewY : CGFloat = navigationBarY! + navigationBarHeight! + 5
        self.customView =  AboutCortexView(frame: CGRectMake((screenWidth-customViewWidth)/2, customViewY, customViewWidth, 413))
        self.customView.layer.borderWidth = 0.8
        self.customView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.customView.layer.cornerRadius = 10
        self.customView.clipsToBounds = true
        
        self.customView.versionLable.text = UserInformation.CORTEX_VERSION
        self.customView.termsOfUseButton.enabled = true
        self.customView.privacyPolicyButton.enabled = true
        
        self.customView.termsOfUseButton.addTarget(self, action: "termsOfUseButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.privacyPolicyButton.addTarget(self, action: "privacyPolicyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.okButton.addTarget(self, action: "dismissAboutView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.alpha = 0
        self.view.addSubview(self.customView!)
        //self.customView.fadeIn(0.25)
    }
    
    func dismissAboutView(sender:UIButton!) {
        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
    }
    
    func termsOfUseButtonTapped(sender:UIButton!) {
        self.customView.termsOfUseButton.enabled = false
        self.customView.privacyPolicyButton.enabled = true

    }
    
    func privacyPolicyButtonTapped(sender:UIButton!) {
        self.customView.privacyPolicyButton.enabled = false
        self.customView.termsOfUseButton.enabled = true

    }
    
    
    // ######################################### FEEDBACK HELPER #########################################
    
    
    // ####################################### DELETE ACCT HELPER ########################################
    
    
}
