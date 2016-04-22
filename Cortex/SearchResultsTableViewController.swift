//
//  SearchResultsTableViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/5/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsTableViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var exportBarButton: UIBarButtonItem!
    
    var searchResultType = InterfaceBuilderInfo.SearchResultType.UNKNOWN
    var searchResultDate = NSDate()
    var searchResultString = ""
    var searchResultInt = -1
    
    var returnedSearchResults = [Thought]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let dataRepo = DataRepository()
    let formatter = NSDateFormatter()
    
    var attachmentImages : [UIImage] = []
    
    var holderView : UIView!
    var customView : AddThoughtNoteView!
    var previousConstant : CGFloat = 0.0
    var keyboardHeightRightNow : CGFloat = -1.0
    var thoughtIndexToAddNote : Int = -1
    var addNoteCustomViewOnDisplay = false
    
    let categoryDataSource = CategoryListDataSource()
    var thoughtIndexToChangeCategory = -1
    var changeCatCustomView : ChangeCategoryView!
    
    //var refreshControl: UIRefreshControl!
    

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
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(SearchResultsTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    override func viewWillAppear(animated: Bool) {
        //setupKeyboardNotifications()
        tableView.reloadData()
        setExportButtonBasedOnNumOfThoughts()
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refresh(sender:AnyObject) {
        print("searchResultType: \(searchResultType)")
        if(searchResultType != InterfaceBuilderInfo.SearchResultType.UNKNOWN) {
            returnedSearchResults.removeAll(keepCapacity: false)
            // Code to refresh table view
            if(searchResultType == InterfaceBuilderInfo.SearchResultType.DATE) {
                returnedSearchResults = dataRepo.getAllCDThoughtsForDate(searchResultDate)
            } else if(searchResultType == InterfaceBuilderInfo.SearchResultType.CATEGORY) {
                returnedSearchResults = dataRepo.getAllCDThoughtsForAttributeValue(searchResultString, attribute: EntityInfo.Thought.categoryString)
            } else if(searchResultType == InterfaceBuilderInfo.SearchResultType.LOCATION) {
                returnedSearchResults = dataRepo.getAllCDThoughtsForAttributeValue(searchResultString, attribute: EntityInfo.Thought.location)
            } else if(searchResultType == InterfaceBuilderInfo.SearchResultType.MOOD) {
                returnedSearchResults = dataRepo.getAllCDThoughtsForMoodValue(searchResultInt)
            } else if(searchResultType == InterfaceBuilderInfo.SearchResultType.KEYWORD) {
                returnedSearchResults = dataRepo.getCDThoughtsByKeywords(searchResultString)
            }
            self.tableView.reloadData()
        }
        
        self.refreshControl?.endRefreshing()
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
        
        cell.editCategoryButton.tag = indexPath.section
        cell.editCategoryButton.addTarget(self, action: #selector(SearchResultsTableViewController.changeCategoryButtonPressed(_:)), forControlEvents: .TouchUpInside)

        
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
        
        //u{282A}
        let share = UITableViewRowAction(style: .Default, title: "Share") { action, index in
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
            self.tableView.setEditing(false, animated: true)

        }
        share.backgroundColor = UIColor.darkGrayColor() //(rgba: "#F6A242")
        
        var noteAction = "Add"
        if(!StringUtils.isBlank(returnedSearchResults[indexPath.section].note)) {
            noteAction = "Edit"
        }
        let addNote = UITableViewRowAction(style: .Normal, title: noteAction+"\nNote") { action, index in
            //print("addNOTE button tapped")
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
            self.displayNoteEditorXib(indexPath.section, height: CGFloat(350))
        }
        addNote.backgroundColor = UIColor.lightGrayColor()//(rgba: "#F6A242")
        
        let thoughtAttachments = returnedSearchResults[indexPath.section].thoughtAttachments
        if(thoughtAttachments != nil && thoughtAttachments?.count > 0) {
            // "\u{263C}\n View\n Attachments" , u{229B}
            let attc = UITableViewRowAction(style: .Normal, title: "View\nImages") { action, index in
                //print("view attachments button tapped")
                self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
                self.getThoughtAttachmentImages(thoughtAttachments)
                self.performSegueWithIdentifier(InterfaceBuilderInfo.SeguePath.showSearchedThoughtAttachments, sender: self)
            }
            attc.backgroundColor = UIColor(rgba: "#7b7d7b") //(rgba: "#00ab84")
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
            //print("missing image at: \(path)")
        }
        //print("Loading image from path: \(path)")
        return image
    }

    
    func deleteThought(thought: Thought) {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.show()
        if(thought.thoughtAttachments != nil && thought.thoughtAttachments?.count > 0) {
            for att in thought.thoughtAttachments! {
                HelperUtils.deleteFileAtPath(att.name)
            }
        }
        self.managedObjectContext?.deleteObject(thought)
        self.dataRepo.save()
        SVProgressHUD.dismiss()
        self.tableView.layoutIfNeeded()
    }
    
    //############################# CHANGE CATEGORY HELPERS #################################
    
    func changeCategoryButtonPressed(sender: UIButton) {
        thoughtIndexToChangeCategory = sender.tag //returnedSearchResults[sender.tag]
        displayChangeCategoryXib()
        
    }
    
    func displayChangeCategoryXib() {
        //Scroll to the top
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
        tableView.scrollEnabled = false
        
        holderView = UIView(frame: self.view.frame)
        holderView.backgroundColor = UIColor.grayColor()
        holderView.alpha = 0.6
        self.view.addSubview(holderView)
        
        let screenWidth : CGFloat = self.view.frame.size.width
        let screenHeight : CGFloat = self.view.frame.size.height
        let tabBarHeight : CGFloat = self.tabBarController!.tabBar.frame.size.height
        let customViewWidth : CGFloat = screenWidth - 30
        let customViewHeight : CGFloat = screenHeight - (tabBarHeight*3) - 10
        let customViewY : CGFloat = 0 + 5
        //print("screenHeight: \(screenHeight) -- tabBarHeight: \(tabBarHeight) -- customViewHeight: \(customViewHeight)")
        self.changeCatCustomView = ChangeCategoryView(frame: CGRectMake((screenWidth-customViewWidth)/2, customViewY, customViewWidth, customViewHeight))
        self.changeCatCustomView.layer.borderWidth = 0.8
        self.changeCatCustomView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.changeCatCustomView.layer.cornerRadius = 10
        self.changeCatCustomView.clipsToBounds = true
        
        self.changeCatCustomView.cancelButton.addTarget(self, action: #selector(SearchResultsTableViewController.cancelEditCategoryButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.changeCatCustomView.saveButton.addTarget(self, action: #selector(SearchResultsTableViewController.saveEditCategoryButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.changeCatCustomView.tableView.dataSource = categoryDataSource
        self.changeCatCustomView.tableView.delegate = categoryDataSource
        self.changeCatCustomView.tableView.reloadData()
        
        self.view.addSubview(self.changeCatCustomView!)
        
    }
    
    func dismissChangeCategoryXib() {
        thoughtIndexToChangeCategory = -1
        self.changeCatCustomView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        tableView.scrollEnabled = true
    }
    
    func cancelEditCategoryButtonTapped(sender:UIButton!) {
        dismissChangeCategoryXib()
    }
    
    func saveEditCategoryButtonTapped(sender:UIButton!) {
        if(!StringUtils.isBlank(categoryDataSource.chosenCategoryString)) {
            let cat = dataRepo.getCDCategoryByCategoryName(categoryDataSource.chosenCategoryString)
            if(cat != nil) {
                if(thoughtIndexToChangeCategory != -1) {
                    //print("--BEFORE SAVING to CD - \(categoryDataSource.chosenCategoryString) -- thoughtIndexToChangeCategory: \(thoughtIndexToChangeCategory)")
                    let thought = self.returnedSearchResults[thoughtIndexToChangeCategory]
                    thought.categoryString = categoryDataSource.chosenCategoryString
                    thought.thoughtCategory = cat
                    self.dataRepo.save()
                }
            }
        }
        
        dismissChangeCategoryXib()
        refresh(self) //reload data
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //############################# ADD NOTE HELPERS #################################
    
    func displayNoteEditorXib(choosenThoughtSection : Int, height: CGFloat) {
        //Scroll to the top
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
        tableView.scrollEnabled = false
        
        addNoteCustomViewOnDisplay = true
        cancelBarButton.enabled = false
        setExportButtonBasedOnNumOfThoughts()
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
        
        self.customView.cancelButton.addTarget(self, action: #selector(SearchResultsTableViewController.cancelNoteButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.saveButton.addTarget(self, action: #selector(SearchResultsTableViewController.saveNoteButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.textFieldView.delegate = self
        
        self.view.addSubview(self.customView!)
        self.customView.textFieldView.becomeFirstResponder()
        self.tableView.setEditing(false, animated: true) //closes the cell that was swiped left.
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.customView.textFieldView.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.customView.textFieldView.resignFirstResponder()
        return true
    }
    
    func cancelNoteButtonTapped(sender:UIButton!) {
        self.customView.textFieldView.endEditing(true)
        self.holderView.endEditing(true)
        self.view.endEditing(true)
        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        thoughtIndexToAddNote = -1
        cancelBarButton.enabled = true
        setExportButtonBasedOnNumOfThoughts()
        addNoteCustomViewOnDisplay = false
        tableView.scrollEnabled = true
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
        setExportButtonBasedOnNumOfThoughts()
        addNoteCustomViewOnDisplay = false
        tableView.scrollEnabled = true
        self.tableView.layoutIfNeeded()
        self.tableView.layoutSubviews()
    }
    
    //############################# KEYBOARD HELPERS #########################################
    
    func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchResultsTableViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWasShown(aNotification:NSNotification) {
        moveTextViewForKeyboard(aNotification, up: true)
    }
    
    func moveTextViewForKeyboard(notification: NSNotification, up: Bool) {
        if (up == true && addNoteCustomViewOnDisplay) {
            let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
            //let keyboardFrame: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

            let keyboardHeight = keyboardSize?.height
           
            if(self.customView.frame.height + keyboardHeight! + 5 >= self.view.frame.height) {
                let height = CGFloat(self.view.frame.height - 75 - keyboardHeight!)
                //print("--final height for addNote XIB: \(height)")
                self.customView.endEditing(true)
                self.customView.removeFromSuperview()
                self.holderView.removeFromSuperview()
                displayNoteEditorXib(thoughtIndexToAddNote, height: height)
            }
        } else {
            if(addNoteCustomViewOnDisplay) {
                // Keyboard is going away (down) - restore original frame
                self.self.customView.textFieldBottomConstraint.constant = previousConstant
                self.customView.layoutIfNeeded()
            }
        }
    }
    
    //############################# EXPORT ALL SEARCH THOUGHTS HELPERS #########################################
    
    
    @IBAction func exportAllSearchResultsBtnPressed(sender: AnyObject) {
        //generatePDFForAllSearchResultThoughts()
        //SVProgressHUD.show()
        var allObjectsToShare = [AnyObject]()
        
        for thought in self.returnedSearchResults  {
            let thisThoughtContent = HelperUtils.convertThoughtToString(thought)
            
            allObjectsToShare.append(thisThoughtContent)
            if(thought.thoughtAttachments?.count > 0) {
                self.getThoughtAttachmentImages(thought.thoughtAttachments)
                allObjectsToShare.append(attachmentImages)
            }
        }
        
        let activityVC = UIActivityViewController(activityItems: allObjectsToShare, applicationActivities: nil)
        activityVC.navigationController?.navigationBar.backgroundColor = UIColor(rgba: "#3CB3B5")
        activityVC.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        activityVC.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        activityVC.view.tintColor = UIColor.redColor() //this only changes the color of CANCEL button
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
        
        if(self.returnedSearchResults.count > 1) {
            activityVC.excludedActivityTypes?.append(UIActivityTypeMessage)
            activityVC.excludedActivityTypes?.append(UIActivityTypePostToTwitter)
        }
        //print("ALL EXCLUDED ACTIVITIES: \(activityVC.excludedActivityTypes)")
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
        
    func generatePDFForAllSearchResultThoughts() {
        // save all table
        var frame = self.tableView.frame;
        frame.size.height = self.tableView.contentSize.height;
        //self.tableView.frame = frame;
        
        UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, self.tableView.opaque, 0.0);
        self.tableView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let saveImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        let imageData = UIImagePNGRepresentation(saveImage);
        
        let image = UIImage(data: imageData!)
        let imageView = UIImageView(image: image)
        createPDFFromImageView(imageView, fileName: "newSearchResults.pdf")
    }
    
    func createPDFFromImageView(inputView: UIView, fileName: String) {
        // Creates a mutable data object for updating with binary data, like a byte array
        let pdfData = NSMutableData()
        
        // Points the pdf converter to the mutable data object and to the UIView to be converted
        UIGraphicsBeginPDFContextToData(pdfData, inputView.bounds, nil);
        UIGraphicsBeginPDFPage();
        let pdfContext = UIGraphicsGetCurrentContext();
        
        // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
        inputView.layer.renderInContext(pdfContext!)
        
        // remove PDF rendering context
        UIGraphicsEndPDFContext();
        
        // Retrieves the document directories from the iOS device
        let documentDirectoryFilename = HelperUtils.fileInDocumentsDirectory(fileName)
        print("PDf path fileName: \(documentDirectoryFilename)")
        
        // instructs the mutable data object to write its context to a file on disk
        pdfData.writeToFile(documentDirectoryFilename, atomically: true)
        //return pdfData
    }
    
    func setExportButtonBasedOnNumOfThoughts() {
        if(self.returnedSearchResults.count < 2) {
            if(navigationItem.rightBarButtonItems != nil && navigationItem.rightBarButtonItems?.count > 0) {
                exportBarButton.enabled = false
                navigationItem.rightBarButtonItems = []
            }
        } else {
            navigationItem.rightBarButtonItems = [exportBarButton]
            exportBarButton.enabled = true
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
