//
//  ShowCategoriesTableViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/18/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData

protocol ShowCategoriesDelegate {
    func selectedCategory(categorySelectedText: String, categorySelectedGuid: String)
}

class ShowCategoriesTableViewController: UITableViewController {
    
    var showCategoriesDelegateVar: ShowCategoriesDelegate?
    
    var holderView : UIView!
    var customView:AddCategoryAlertView!
    
    @IBOutlet weak var addCategoryButton: UIBarButtonItem!
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let currUsername = NSUserDefaults.standardUserDefaults().stringForKey(UserInformation.USER_EMAIL)
    var categories = [Category]()
    
    let dataRepo = DataRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        categories = dataRepo.getAllCategories()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categoryInputTextFieldChanged:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        //self.navigationController!.navigationBar.translucent = NO;
    }
    
    override func viewWillAppear(animated: Bool) {
        if(categories.count <= 0) {
            let noDataMessage = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width,self.tableView.bounds.size.height))
            noDataMessage.text = "No Categories"
            noDataMessage.textAlignment = NSTextAlignment.Center
            noDataMessage.sizeToFit()
            noDataMessage.textColor = UIColor.lightGrayColor()
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            self.tableView.backgroundView = noDataMessage
            self.tableView.backgroundColor = UIColor(rgba: "#232323")
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.backgroundView = nil
            self.tableView.backgroundColor = UIColor.whiteColor()
        }
        //animateTable()
    }
    
    func categoryInputTextFieldChanged(sender: NSNotification) {
        let inputCategory = customView.categoryInput.text
        
        if(StringUtils.isBlank(inputCategory)) {
            self.customView.saveButton.enabled = false
        } else {
            self.customView.saveButton.enabled = true
        }
    }
    
    @IBAction func addNewCategoryButtonPressed(sender: AnyObject) {
        //FYI - selection of other cells is disabled at this point. User can just scroll the table
        tableView.scrollEnabled = false
        addCategoryButton.enabled = false
        //Scroll to the top
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);

        holderView = UIView(frame: self.view.frame)
        holderView.backgroundColor = UIColor.grayColor()
        holderView.alpha = 0.6
        self.view.addSubview(holderView)
        
        let screenWidth : CGFloat = self.view.frame.size.width
        let customViewWidth : CGFloat = screenWidth - 30
        
        
        /*let navigationBarY = self.navigationController?.navigationBar.frame.origin.y
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        let y = tableView.contentOffset.y
        print("==========navigationBarY : \(navigationBarY)")
        print("==========navigationBarHeight : \(navigationBarHeight)")
        print("==========OFFSET : \(y)")*/

        
        //TODO - change customViewY so it's not always stuck to the top if the table view has many contents
        let customViewY : CGFloat = 0 + 5 //navigationBarY! + navigationBarHeight! + 5
        self.customView =  AddCategoryAlertView(frame: CGRectMake((screenWidth-customViewWidth)/2, customViewY, customViewWidth, 125))
        self.customView.layer.borderWidth = 0.8
        self.customView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.customView.layer.cornerRadius = 10
        self.customView.clipsToBounds = true
        
        self.customView.saveButton.enabled = false
        self.customView.cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.saveButton.addTarget(self, action: "saveButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.customView!);

    }
    
    func cancelButtonTapped(sender:UIButton!) {
        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        addCategoryButton.enabled = true
        tableView.scrollEnabled = true
    }
    
    func saveButtonTapped(sender:UIButton!) {
        let finalCat = self.customView.categoryInput.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) //no lowercase
        
        if(dataRepo.getCDCategoryByCategoryName(finalCat!) == nil) {
            let newCategory = saveNewCategoryToCD(finalCat!)
            
            // Update the array containing the table view row data
            categories = dataRepo.getAllCategories()
            
            if let newItemIndex = categories.indexOf(newCategory) {
                // Create an NSIndexPath from the newItemIndex
                let newCategoryItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
                tableView.insertRowsAtIndexPaths([ newCategoryItemIndexPath ], withRowAnimation: .Automatic)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.tableView.backgroundView = nil
                self.tableView.backgroundColor = UIColor.whiteColor()
            }
        }
        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        addCategoryButton.enabled = true
        tableView.scrollEnabled = true
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InterfaceBuilderInfo.CellIdentifiers.categoryCell, forIndexPath: indexPath)

        cell.textLabel?.text = categories[indexPath.row].category
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print("didSelectRowAtIndexPath - \(categories[indexPath.row].category)")
        
        self.showCategoriesDelegateVar?.selectedCategory(categories[indexPath.row].category!, categorySelectedGuid: categories[indexPath.row].guid!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let categoryThoughts = dataRepo.getAllCDThoughtsForAttributeValue(categories[indexPath.row].category!, attribute: EntityInfo.Thought.categoryString)
        if(categoryThoughts.isEmpty) {
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Default, title: "\u{2715}") { action, index in
            print("delete button tapped")
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
        }
        delete.backgroundColor = UIColor(rgba: "#ef3340")
        return [delete]
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this category?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let deleteOption = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (alert) -> Void in
                let categoryToBeDeleted = self.categories[indexPath.row]
                self.categories.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                
                self.deleteCategory(categoryToBeDeleted)
            })
            
            alert.addAction(deleteOption)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: {})
        }
        tableView.layoutIfNeeded()
    }
    
    func saveNewCategoryToCD(newCategoryValue: String) -> Category {
        let guid = NSUUID().UUIDString
        let newCategoryCDObject = Category.createNewCategoryInMOC(self.managedObjectContext!, text: newCategoryValue, guid: guid)
        dataRepo.save()
        
        print("Created NEW NEEDS_TO_BE_SYNCED CD category with guid: \(guid) for user: \(currUsername)")
        return newCategoryCDObject
    }

    func deleteCategory(category: Category) {
        managedObjectContext!.deleteObject(category as NSManagedObject)
        self.dataRepo.save()
    }
    
    // ################################# HELPERS ################################
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(0.5, delay: 0.03 * Double(index), usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
 
}
