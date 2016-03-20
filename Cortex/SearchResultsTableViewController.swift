//
//  SearchResultsTableViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/5/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsTableViewController: UITableViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    var returnedSearchResults = [Thought]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let dataRepo = DataRepository()
    let formatter = NSDateFormatter()
    
    var attachmentImages : [UIImage] = []
    
    var holderView : UIView!
    var customView : AddThoughtNoteView!
    var previousConstant : CGFloat = 0.0
    var thoughtIndexToAddNote : Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        setupKeyboardNotifications()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    //######################################### TABLE VIEW METHODS #############################################

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return returnedSearchResults.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InterfaceBuilderInfo.CellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultTableViewCell
        
        cell.dateLabel.text = formatter.stringFromDate(returnedSearchResults[indexPath.section].createdAt!)
        
        let thoughtCat = returnedSearchResults[indexPath.section].thoughtCategory?.category
        if(StringUtils.isBlank(thoughtCat)) {
            cell.categoryLabel.text = "N/A"
        } else {
            cell.categoryLabel.text = returnedSearchResults[indexPath.section].thoughtCategory?.category
        }
        
        let thoughtLocation = returnedSearchResults[indexPath.section].location
        if(StringUtils.isBlank(thoughtLocation)) {
            cell.locationLabel.text = "N/A"
        } else {
            cell.locationLabel.text = returnedSearchResults[indexPath.section].location
        }
        
        cell.thoughtContent.text = returnedSearchResults[indexPath.section].thoughtContent
        let moodInt : Int = returnedSearchResults[indexPath.section].mood as! Int
        cell.moodImageView.image = HelperUtils.setMoodButtonImage(moodInt)
        cell.moodInt = moodInt
        
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        return cell
    }
    
    //267A - delete recycle
    //2606 - empty star
    //2605 - filled in star
    //232B - delete, backspace
    //2661 - heart for favorite
    //2709 - envelope
    //270E ------ pencil for share, but want to use for edit!!
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        //2715
        //232B
        let delete = UITableViewRowAction(style: .Default, title: "\u{2715}") { action, index in
            print("delete button tapped")
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
        }
        delete.backgroundColor = UIColor(rgba: "#ef3340")
        
        let share = UITableViewRowAction(style: .Default, title: "\u{282A}\nShare") { action, index in
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
            
            var allObjectsToShare = [AnyObject]()
            allObjectsToShare.append(self.returnedSearchResults[indexPath.section].thoughtContent!)
            if(self.returnedSearchResults[indexPath.section].thoughtAttachments?.count > 0) {
                self.getThoughtAttachmentImages(self.returnedSearchResults[indexPath.section].thoughtAttachments)
                for att in self.attachmentImages {
                    allObjectsToShare.append(att)
                }
            }

            let activityVC = UIActivityViewController(activityItems: allObjectsToShare, applicationActivities: nil)
            activityVC.navigationController?.navigationBar.backgroundColor = UIColor(rgba: "#3CB3B5")
            activityVC.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
            activityVC.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGrayColor()]
            activityVC.view.tintColor = UIColor.redColor() ///this only changes the color of CANCEL button
            /*if #available(iOS 9.0, *) {
                UINavigationBar.appearanceWhenContainedInInstancesOfClasses([SearchResultsTableViewController.self]).backgroundColor = UIColor.greenColor()
            } else {
                // Fallback on earlier versions
            }*/
            //New Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList,
                                                UIActivityTypePostToWeibo,
                                                UIActivityTypePrint,
                                                UIActivityTypeAirDrop,
                                                UIActivityTypeAssignToContact,
                                                UIActivityTypePostToVimeo,
                                                UIActivityTypePostToTencentWeibo]
            //
            self.presentViewController(activityVC, animated: true, completion: nil)

        }
        share.backgroundColor = UIColor.darkGrayColor() //(rgba: "#F6A242")
        
        var noteAction = "Add"
        if(!StringUtils.isBlank(returnedSearchResults[indexPath.section].note)) {
            noteAction = "Edit"
        }
        let addNote = UITableViewRowAction(style: .Normal, title: "+\n"+noteAction+"\nNote") { action, index in
            print("addNOTE button tapped")
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
            self.displayNoteEditorXib(indexPath.section, height: CGFloat(350))
        }
        addNote.backgroundColor = UIColor(rgba: "#F6A242")
        
        let thoughtAttachments = returnedSearchResults[indexPath.section].thoughtAttachments
        if(thoughtAttachments != nil && thoughtAttachments?.count > 0) {
            // "\u{263C}\n View\n Attachments"
            let attc = UITableViewRowAction(style: .Normal, title: "\u{229B}\nView\nImages") { action, index in
                print("view attachments button tapped")
                self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
                self.getThoughtAttachmentImages(thoughtAttachments)
                self.performSegueWithIdentifier(InterfaceBuilderInfo.SeguePath.showSearchedThoughtAttachments, sender: self)
            }
            attc.backgroundColor = UIColor.lightGrayColor() //(rgba: "#DEBD3E") //(rgba: "#00ab84")
            return [delete, share, attc, addNote]
        }
        
        return [delete, share, addNote]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            let alert = UIAlertController(title: "Warning", message: "This thought content and any attachments and notes will be deleted. This action cannot be undone. It is recommened that thoughts aren't deleted to keep an accurate record. Are you sure you want to proceed?", preferredStyle: UIAlertControllerStyle.ActionSheet)

            let deleteOption = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (alert) -> Void in
                let thoughtToBeDeleted = self.returnedSearchResults[indexPath.section]
                self.returnedSearchResults.removeAtIndex(indexPath.section)
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                
                self.deleteThought(thoughtToBeDeleted)
            })
            
            alert.addAction(deleteOption)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: {})
        }
        tableView.layoutIfNeeded()
    }
    
    func getThoughtAttachmentImages(atts : NSSet?) {
        attachmentImages.removeAll(keepCapacity: false)
        for att in atts! {
            let one = att as! Attachment
            let photoName = one.name //guid.png
            let imageFileFullPath = HelperUtils.fileInDocumentsDirectory(photoName!) //whatever main directory+imageName
            if let img = loadImageFromPath(imageFileFullPath) {
                attachmentImages.append(img)
            }
        }
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)")
        return image
    }

    
    func deleteThought(thought: Thought) {
        print("Set delete flag to 1 and remove from CD if parse flag was also updated for guid: \(thought.guid)")
        /*thought.setValue(1, forKey: EntityInfo.Thought.isThoughtDeleted)
        thought.setValue(NSDate(), forKey: EntityInfo.Thought.lastModified_CD_ONLY)
        self.dataRepo.save()*/
        
        self.managedObjectContext?.deleteObject(thought)
        self.dataRepo.save()
    }
    
    //############################# ADD NOTE HELPERS #################################
    
    func displayNoteEditorXib(choosenThoughtSection : Int, height: CGFloat) {
        //FYI - selection of other cells is disabled at this point. User can just scroll the table
        cancelBarButton.enabled = false
        
        thoughtIndexToAddNote = choosenThoughtSection
        
        holderView = UIView(frame: self.view.frame)
        holderView.backgroundColor = UIColor.grayColor()
        holderView.alpha = 0.6
        self.view.addSubview(holderView)
        
        let screenWidth : CGFloat = self.view.frame.size.width
        let customViewWidth : CGFloat = screenWidth - 30
        let customViewY : CGFloat = 0 + 5
        //let height = CGFloat(350)
        self.customView = AddThoughtNoteView(frame: CGRectMake((screenWidth-customViewWidth)/2, customViewY, customViewWidth, height))
        self.customView.layer.borderWidth = 0.8
        self.customView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.customView.layer.cornerRadius = 10
        self.customView.clipsToBounds = true
        
        let thought = self.returnedSearchResults[thoughtIndexToAddNote]
        if(!StringUtils.isBlank(thought.note)) {
            self.customView.textFieldView.text = thought.note
        }
        
        self.customView.cancelButton.addTarget(self, action: "cancelNoteButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.saveButton.addTarget(self, action: "saveNoteButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.customView!)
    }
    
    func cancelNoteButtonTapped(sender:UIButton!) {
        self.customView.textFieldView.resignFirstResponder()
        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        thoughtIndexToAddNote = -1
        cancelBarButton.enabled = true
    }
    
    func saveNoteButtonTapped(sender:UIButton!) {
        let newThoughtNote = self.customView.textFieldView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) //no lowercase
        
        if(thoughtIndexToAddNote != -1) { //not checking empty, because they can clear the note
            let thought = self.returnedSearchResults[thoughtIndexToAddNote]
            thought.note = newThoughtNote
            self.dataRepo.save()
        }
        
        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        thoughtIndexToAddNote = -1
        cancelBarButton.enabled = true
    }
    
    //############################# KEYBOARD HELPERS #########################################
    
    func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWasShown(aNotification:NSNotification) {
        moveTextViewForKeyboard(aNotification, up: true)
    }
    
    func moveTextViewForKeyboard(notification: NSNotification, up: Bool) {
        if (up == true) {
            let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
            let keyboardFrame: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

            let keyboardHeight = keyboardSize?.height
            print("FULL FRAME :: \(self.view.frame) = height: \(self.view.frame.height)")
            print("KEYBOARD FRAME :: \(keyboardFrame) = height: \(keyboardFrame.height)")
            print("CUSTOM VIEW FRAME :: \(self.customView.frame) = height: \(self.customView.frame.height)")
            
            
            //print("++ frameHeight: \(self.view.frame.height) -- keyboardHeight: \(keyboardHeight) -- xib height: \(self.customView.frame.height)")
            
            //self.customView.frame.origin.y = -150 //no luck, moves the whole frame up, but I need just the height to shrink!
            
            if(self.customView.frame.height + keyboardHeight! + 5 >= self.view.frame.height) {
                print("YESSSS")
                
                //20 is usually the status bar height, so 20 +5 gave me 319
                let height = CGFloat(self.view.frame.height - 75 - keyboardHeight!)
                print("----final height: \(height)")
                self.customView.removeFromSuperview()
                self.holderView.removeFromSuperview()
                displayNoteEditorXib(thoughtIndexToAddNote, height: height)
                
                /*previousConstant = self.customView.textFieldBottomConstraint.constant
                print("previousConstant: \(previousConstant)")
                self.customView.textFieldBottomConstraint.constant = keyboardHeight! - 125
                //print("after: \(self.textViewBottmConstraint.constant)")*/
                /*UIView.animateWithDuration(0.2) { () -> Void in
                    let screenWidth : CGFloat = self.view.frame.size.width
                    let customViewWidth : CGFloat = screenWidth - 30
                    let customViewY : CGFloat = 0 + 5
                    let height = CGFloat(self.customView.frame.height - keyboardHeight!)
                    self.customView = AddThoughtNoteView(frame: CGRectMake((screenWidth-customViewWidth)/2, customViewY, customViewWidth, height))
                    self.customView.layer.borderWidth = 0.8
                    self.customView.layer.borderColor = UIColor.lightGrayColor().CGColor
                    self.customView.layer.cornerRadius = 10
                    self.customView.clipsToBounds = true
                    self.customView.layoutIfNeeded()
                }*/
            }
        } else {
            // Keyboard is going away (down) - restore original frame
            self.self.customView.textFieldBottomConstraint.constant = previousConstant
            self.customView.layoutIfNeeded()
        }
    }
    
    //############################# SEGUE/MEMORY HELPERS #########################################
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if let viewController = segue.destinationViewController as? SearchedThoughtAttachmentsViewController {
            viewController.pageImages = attachmentImages
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
