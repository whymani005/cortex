//
//  EntryViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class EntryViewController: UIViewController, ShowCategoriesDelegate, UITextViewDelegate, CLLocationManagerDelegate, AttachmentDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let dataRepo = DataRepository()

    var selectedCategoryCDObjectGuid = ""
    var selectedCategoryCDObjectText = ""
    var myCurrentLocationString : String = ""
    var myCurrentLatitude : Double = InterfaceBuilderInfo.Constants.DEFAULT_LOC_NO_WIFI
    var myCurrentLongitude : Double = InterfaceBuilderInfo.Constants.DEFAULT_LOC_NO_WIFI
    var selectedMood : Int = InterfaceBuilderInfo.Constants.DEFAULT_MOOD_VALUE
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var thoughtContentTextView: UITextView!
    @IBOutlet weak var textViewBottmConstraint: NSLayoutConstraint!
    var previousConstant : CGFloat = 0.0
    
    @IBOutlet weak var attachmentBarButtonItemOutlet: UIBarButtonItem!
    @IBOutlet weak var saveBarButtonItemOutlet: UIBarButtonItem!
    @IBOutlet weak var clearBarButtonItemOutlet: UIBarButtonItem!
    
    let customButton: UIButton = UIButton()
    let dateFormatter = NSDateFormatter()
    
    var holderView : UIView!
    var customView : ShowQuoteView!
    
    var attachmentImages : [UIImage] = []
    
    var selectedCategory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 1
        setupLocationManager()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //view.addGestureRecognizer(tap)
        
        thoughtContentTextView.delegate = self
        //thoughtContentTextView.becomeFirstResponder()
        thoughtContentTextView.text = "Enter your thought..."
        thoughtContentTextView.textColor = UIColor.lightGrayColor()
        
        saveBarButtonItemOutlet.enabled = false
                
        selectedCategory = false
        categoryButton.titleLabel?.sizeToFit()
        categoryButton.layer.cornerRadius = 8.0
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        print("heyyy")
    }
    
    override func viewWillAppear(animated: Bool) {
        thoughtContentTextView.flashScrollIndicators()

        self.view.backgroundColor = UIColor.whiteColor()
        setSaveButtonBasedOnInput()
        setupKeyboardNotifications()
        changeIconBasedOnNumOfAttachments()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
  
 
    //############################################ TEXT/KEYBOARD/DELEGATE METHODS ##############################################
    
    func textViewDidBeginEditing(textView: UITextView) {
        if(textView.textColor == UIColor.lightGrayColor()) {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
        clearBarButtonItemOutlet.enabled = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(StringUtils.isBlank(textView.text)) {
            thoughtContentTextView.text = "Enter your thought..."
            thoughtContentTextView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        if(!StringUtils.isBlank(textView.text)) {
            clearBarButtonItemOutlet.enabled = true
        } else if(!clearBarButtonItemOutlet.enabled && StringUtils.isBlank(textView.text)) {
            clearBarButtonItemOutlet.enabled = false
        }
        setSaveButtonBasedOnInput()
    }
    
    func setSaveButtonBasedOnInput() {
        let isCategorySelectionEmpty = StringUtils.isBlank(selectedCategoryCDObjectText)
        let isThoughtViewEmpty = StringUtils.isBlank(thoughtContentTextView.text) || (StringUtils.equals(thoughtContentTextView.text, optionalTwo: "Enter your thought..."))
        
        if(isCategorySelectionEmpty || isThoughtViewEmpty) {
            saveBarButtonItemOutlet.enabled = false
        } else {
            saveBarButtonItemOutlet.enabled = true
        }
    }

    func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func moveTextViewForKeyboard(notification: NSNotification, up: Bool) {
        if up == true {
            let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
            let keyboardHeight = keyboardSize?.height
            //print("++ frameHeight: \(self.view.frame.height) -- keyboardHeight: \(keyboardHeight)")
            
            previousConstant = self.textViewBottmConstraint.constant
            //print("previousConstant: \(previousConstant)")
            self.textViewBottmConstraint.constant = keyboardHeight! - 25
            //print("after: \(self.textViewBottmConstraint.constant)")
            UIView.animateWithDuration(0.2) { () -> Void in
                self.view.layoutIfNeeded()
            }
        } else {
            // Keyboard is going away (down) - restore original frame
            self.textViewBottmConstraint.constant = previousConstant
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWasShown(aNotification:NSNotification) {
        moveTextViewForKeyboard(aNotification, up: true)
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification) {
        moveTextViewForKeyboard(aNotification, up: false)
    }
    
    func selectedCategory(categorySelectedText: String, categorySelectedGuid: String) {
        self.categoryButton.setTitle(categorySelectedText, forState: .Normal)
        self.selectedCategoryCDObjectGuid = categorySelectedGuid
        self.selectedCategoryCDObjectText = categorySelectedText
        
        if(self.selectedCategory == false) {
            categoryButton.layer.borderColor = UIColor.darkGrayColor().CGColor //UIColor(rgba: "#7f8c8d").CGColor
            categoryButton.layer.backgroundColor = UIColor.whiteColor().CGColor
            categoryButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        self.selectedCategory = true
        clearBarButtonItemOutlet.enabled = true
    }
    
    //############################################### CLEAR METHODS ####################################################
    
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        clearThoughtScreen()
        /*thoughtContentTextView.resignFirstResponder()
        self.textViewBottmConstraint.constant = 10
        self.view.layoutIfNeeded()*/
    }
    
    func clearThoughtScreen() {
        
        thoughtContentTextView.resignFirstResponder()
        self.textViewBottmConstraint.constant = 10
        self.view.layoutIfNeeded()
        
        clearBarButtonItemOutlet.enabled = false
        saveBarButtonItemOutlet.enabled = false
        
        //Category
        self.selectedCategory = false
        selectedCategoryCDObjectGuid = ""
        selectedCategoryCDObjectText = ""
        categoryButton.layer.borderColor = UIColor.whiteColor().CGColor
        categoryButton.layer.backgroundColor = UIColor.darkGrayColor().CGColor //UIColor(rgba: "#7f8c8d").CGColor
        categoryButton.setTitleColor(UIColor(rgba: "#EDEDED"), forState: UIControlState.Normal)
        categoryButton.setTitle("Select Category", forState: .Normal)
        
        //Thought box
        thoughtContentTextView.text = "Enter your thought..."
        thoughtContentTextView.textColor = UIColor.lightGrayColor()
        
        //Attachments
        attachmentImages.removeAll(keepCapacity: false)
        attachmentBarButtonItemOutlet.image = UIImage(named: "addAttachmentEmpty.png")!
        
        //Mood
        //change old mood to gray image
        let oldMoodButton : UIButton =  self.view.viewWithTag(selectedMood) as! UIButton
        setMoodButtonImage(oldMoodButton, isGray: true)
        selectedMood = InterfaceBuilderInfo.Constants.DEFAULT_MOOD_VALUE
        //set new mood to color image
        let newMoodButton : UIButton =  self.view.viewWithTag(selectedMood) as! UIButton
        setMoodButtonImage(newMoodButton, isGray: false)
        
        myCurrentLatitude = InterfaceBuilderInfo.Constants.DEFAULT_LOC_NO_WIFI
        myCurrentLongitude = InterfaceBuilderInfo.Constants.DEFAULT_LOC_NO_WIFI
    }
    
    //############################################### MOOD METHODS ####################################################

    
    @IBAction func moodSelected(sender: UIButton) {
        if(sender.tag != selectedMood) {
            let newSelectedMood = sender.tag
            
            //change old mood to gray image
            let oldMoodButton : UIButton =  self.view.viewWithTag(selectedMood) as! UIButton
            setMoodButtonImage(oldMoodButton, isGray: true)
            
            //set new mood to color image
            let newMoodButton : UIButton =  self.view.viewWithTag(newSelectedMood) as! UIButton
            setMoodButtonImage(newMoodButton, isGray: false)
            
            //update mood
            selectedMood = newSelectedMood
            clearBarButtonItemOutlet.enabled = true
        }
    }
    
    func setMoodButtonImage(button: UIButton, isGray: Bool) {
        let image = setMoodImage(button.tag, isGray: isGray)
        button.setImage(image, forState: .Normal)
    }
    
    func setMoodImage(buttonTag : Int, isGray: Bool) -> UIImage {
        var append = ""
        if(isGray) {
            append = "Gray"
        }
        switch buttonTag {
            case 1:
                return (UIImage(named: "crying"+append))!
            case 2:
                return (UIImage(named: "sad"+append))!
            case 3:
                return (UIImage(named: "confused"+append))!
            case 4:
                return (UIImage(named: "neutral"+append))!
            case 5:
                return (UIImage(named: "happy"+append))!
            case 6:
                return (UIImage(named: "lol"+append))!
            default :
                return (UIImage(named: "neutral"+append))!
        }
    }
    
    //############################################### SAVE THOUGHT METHODS ####################################################
    
    @IBAction func saveThoughtButtonPressed(sender: AnyObject) {
        clearBarButtonItemOutlet.enabled = false
        attachmentBarButtonItemOutlet.enabled = false
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.show()
        //self.view.alpha = 0.7
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let thoughtGUID = NSUUID().UUIDString
        let selectedCategoryCDObject = self.dataRepo.getCDCategoryByGuid(self.selectedCategoryCDObjectGuid)

        //Create the thought with content, guid
        if(StringUtils.isBlank(myCurrentLocationString)) {
            myCurrentLocationString = "Not Available"
        }
        
        self.saveNewThoughtWithCategory(selectedCategoryCDObject!, newThoughtGuid: thoughtGUID, thoughtTextString: self.thoughtContentTextView.text)
        
        if(selectedCategoryCDObject != nil) {
            selectedCategoryCDObject!.setValue(NSDate(), forKey: EntityInfo.Category.lastModified_CD_ONLY)
            self.dataRepo.save()
            print("Updated CD category with guid: \(selectedCategoryCDObject!.guid) to ALREADY_SYNCED")
        }
        
        //self.view.alpha = 1.0
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        //show success alert?
        clearThoughtScreen()
        clearBarButtonItemOutlet.enabled = true
        attachmentBarButtonItemOutlet.enabled = true
        SVProgressHUD.dismiss()
    }
    
    func saveNewThoughtWithCategory(cdCategoryObject: Category, newThoughtGuid: String, var thoughtTextString: String) {
        thoughtTextString = thoughtTextString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let createDate = NSDate()
        
        //***************************************************************************************************
        
        //MAIN THREAD - SAVE THOUGHT TO CD
        let newCDThought = Thought.createNewThoughtInMOC(self.managedObjectContext!, category: cdCategoryObject, categoryString: cdCategoryObject.category, mood: self.selectedMood, location: self.myCurrentLocationString, thoughtText: thoughtTextString, guid: newThoughtGuid, createdAt: createDate)
        self.dataRepo.save()
        //saveSearchWordsForThought(thoughtTextString, thought: newCDThought)
        print("Created NEW NEEDS_TO_BE_SYNCED CD thought with guid: \(newThoughtGuid)")
        
        //MAIN THREAD - SAVE ATT TO CD
        if(!self.attachmentImages.isEmpty && self.attachmentImages.count > 0) {
            print("Number of attachments for this thought: \(self.attachmentImages.count)")
            for attachment in self.attachmentImages {
                let attachmentGUID = NSUUID().UUIDString
                
                // Define image name
                let imageName = attachmentGUID+".png"
                let imagePath = HelperUtils.fileInDocumentsDirectory(imageName)
                //let attOrientation = attachment.imageOrientation.rawValue
                let success = saveImage(attachment.correctlyOrientedImage(), path: imagePath)
                if(success) {
                    _ = Attachment.createNewAttachmentInMOC(self.managedObjectContext!, name: imageName, thought: newCDThought, guid: attachmentGUID)
                    self.dataRepo.save()
                    print("Created CD attachemnt with guid: \(attachmentGUID)")
                }
            }
        }
        
        newCDThought.setValue(NSDate(), forKey: EntityInfo.Thought.lastModified_CD_ONLY)
        self.dataRepo.save()
        print("Updated CD thought with guid: \(newThoughtGuid) to ALREADY_SYNCED")
        
    }
    
    //################################################ LOCATION METHODS ###################################################
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //this will request access from the user to their location data
        locationManager.requestWhenInUseAuthorization()
        //inidcation of how good we want our location data to be
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        //set a min distance a device must more horizontal before an update event is genrated for our event
        locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()
    }
    
    //called when user changes authorization status for this app
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
            // User has not yet made a choice with regards to this application
        case .NotDetermined :
            manager.requestWhenInUseAuthorization()
            print("prompt the user to enable location services")
            
            // User has explicitly denied authorization for this application, or
            // location services are disabled in Settings.
        case .Denied :
            print("prompt the user to re-enable location services in settings")
            
            // User has granted authorization to use their location only when your app
            // is visible to them (it will be made visible to them if you continue to
            // receive location updates while in the background).  Authorization to use
            // launch APIs has not been granted.
        case .AuthorizedWhenInUse :
            manager.startUpdatingLocation()
            print("authorized when in use")
            
            // Currently only .Restricted falls here and there's not much we can do about it
            // so we'll simply move on with our lives
        default :
            //do nothing
            print("Other status")
        }
    }
    
    //responds to a location update event
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last as CLLocation!
        print("didUpdateLocations:  \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
        self.myCurrentLatitude = currentLocation.coordinate.latitude
        self.myCurrentLongitude = currentLocation.coordinate.longitude
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
            
            if error == nil && placemarks?.count > 0 {
                let placemark = placemarks!.last as CLPlacemark?
                var addressString : String = ""
                
                if placemark!.locality != nil {
                    addressString = addressString + placemark!.locality! + ", "
                }
                if placemark!.administrativeArea != nil {
                    addressString = addressString + placemark!.administrativeArea! + " "
                }
                if placemark!.country != nil {
                    addressString = addressString + placemark!.country!
                }
                self.myCurrentLocationString = addressString
                print("LOCATION ------------ \(addressString)")
            }
        })
    }
    
    
    //################################################ HELPER METHODS ###################################################

    func saveSearchWordsForThought(thoughtTextString: String, thought: Thought) {
        let thoughtTokens = StringUtils.tokenize(thoughtTextString)
        print("%%%%% TOKENS -- \(thoughtTokens)")
        /*for token : AnyObject in thoughtTokens {
            if let sw = dataRepo.getSearchEntityByKeyword(token as! String) {
                sw.thoughts?.addObject(thought)
            } else {
                Search.createNewSearchWordInMOC(managedObjectContext!, keyword: token as! String, thought: thought)
            }
            dataRepo.save()
        }*/
    }
    
    func changeIconBasedOnNumOfAttachments() {
        if(attachmentImages.count > 0) {
            clearBarButtonItemOutlet.enabled = true
        }
        
        if(attachmentImages.count == 1) {
            attachmentBarButtonItemOutlet.image = UIImage(named: "oneAttachment.png")!
        } else if(attachmentImages.count == 2) {
            attachmentBarButtonItemOutlet.image = UIImage(named: "twoAttachment.png")!
        } else if(attachmentImages.count == 3) {
            attachmentBarButtonItemOutlet.image = UIImage(named: "threeAttachment.png")!
        } else {
            attachmentBarButtonItemOutlet.image = UIImage(named: "addAttachmentEmpty.png")!
        }
    }
    
    func saveImage(image: UIImage, path: String ) -> Bool{
        print("SAVING IMAGE TO PATH: \(path)")
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
    }

    //################################################ MEMORY/SEGUE METHODS ###################################################

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let viewController = segue.destinationViewController as? ShowCategoriesTableViewController {
            viewController.showCategoriesDelegateVar = self
        }
        
        if let viewController = segue.destinationViewController as? AttachmentsScrollViewController {
            viewController.attachmentDelegateVar = self
            viewController.pageImages = attachmentImages
        }
    }
    
    func attachmentVCDismissed(attachments: [UIImage]) {
        attachmentImages = attachments
        print("# attachments in entryVC coming in from attachmentVC: \(attachmentImages.count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



