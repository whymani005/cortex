//
//  HistoryViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, CalendarViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var defaultSelection : Bool = true
    var searchResults = [Thought]()
    var categories = [Category]()
    var locations = [NSDictionary]()
    let dataRepo = DataRepository()
    
    @IBOutlet weak var calendarPlaceholderView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moodBaseView: UIView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var holderView : UIView!
    var customView : SearchByKeyword!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSelection = true
        // Do any additional setup after loading the view.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: InterfaceBuilderInfo.CellIdentifiers.historyCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.backgroundColor = UIColor.clearColor()
        //tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        setupCalendarView()

        // todays date.
        let date = NSDate()
        
        // create an instance of calendar view with
        // base date (Calendar shows 12 months range from current base date)
        // selected date (marked dated in the calendar)
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarPlaceholderView.hidden = false
        calendarPlaceholderView.addSubview(calendarView)
        
        // Constraints for calendar view - Fill the parent view.
        calendarPlaceholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        calendarPlaceholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        
        //tableView.clearsSelectionOnViewWillAppear = true
    }
    
    @IBAction func segmentedControlPressed(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0) {
            setupCalendarView()
        } else if(segmentedControl.selectedSegmentIndex == 1) {
            setupTableView()
            categories = dataRepo.getAllCategories()
            tableView.reloadData()
        } else if(segmentedControl.selectedSegmentIndex == 2) {
            setupTableView()
            locations = dataRepo.getAllLocations()
            tableView.reloadData()
        } else if(segmentedControl.selectedSegmentIndex == 3) {
            setupMoodView()
        }
    }
    
    func setupCalendarView() {
        calendarPlaceholderView.hidden = false
        calendarPlaceholderView.userInteractionEnabled = true
        
        tableView.hidden = true
        tableView.userInteractionEnabled = false
        
        moodBaseView.hidden = true
        moodBaseView.userInteractionEnabled = false
    }
    
    func setupTableView() {
        calendarPlaceholderView.hidden = true
        calendarPlaceholderView.userInteractionEnabled = false
        
        tableView.hidden = false;
        tableView.userInteractionEnabled = true
        
        moodBaseView.hidden = true
        moodBaseView.userInteractionEnabled = false
    }
    
    func setupMoodView() {
        calendarPlaceholderView.hidden = true
        calendarPlaceholderView.userInteractionEnabled = false
        
        tableView.hidden = true;
        tableView.userInteractionEnabled = false
        
        moodBaseView.hidden = false
        moodBaseView.userInteractionEnabled = true
    }
    
    func didSelectDate(date: NSDate) {
        if(defaultSelection) {
            print("--- default select --- \(date.day) ---")
            defaultSelection = false
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            print("\(date.year)-\(date.month)-\(date.day) **click**")
            
            searchResults = dataRepo.getAllCDThoughtsForDate(date)
            actionAfterSearchCriteriaSelection(formatter.stringFromDate(date))
        }
    }

    @IBAction func moodCriteriaSelected(sender: AnyObject) {
        searchResults = dataRepo.getAllCDThoughtsForMoodValue(sender.tag)
        actionAfterSearchCriteriaSelection("selected mood")
    }
    
    func actionAfterSearchCriteriaSelection(criteria: String) {
        if(searchResults.isEmpty || searchResults.count <= 0) {
            let message = "for \(criteria)"
            print(message)
            //ALERT
            let titlePrompt = UIAlertController(title: "No Entries Found",
                message: message,
                preferredStyle: .Alert)
            titlePrompt.addAction(UIAlertAction(title: "Ok",
                style: .Cancel,
                handler: {nil}()
                ))
            self.presentViewController(titlePrompt,
                animated: true,
                completion: nil)
        } else {
            let message = "Found \(searchResults.count) entries for \(criteria)"
            print(message)
            self.performSegueWithIdentifier(InterfaceBuilderInfo.SeguePath.goToSearchResults, sender: self)
        }
    }
    
    /*func colorForIndex(index: Int) -> UIColor {
        if(segmentedControl.selectedSegmentIndex == 1) {
            let itemCount = categories.count - 1
            let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
            return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
        } else if(segmentedControl.selectedSegmentIndex == 2)  {
            let itemCount = locations.count - 1
            let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
            return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
        }
        return UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }*/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(segmentedControl.selectedSegmentIndex == 1) {
            return categories.count
        } else if(segmentedControl.selectedSegmentIndex == 2) {
            return locations.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(segmentedControl.selectedSegmentIndex == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(InterfaceBuilderInfo.CellIdentifiers.historyCell, forIndexPath: indexPath)
            
            let row = indexPath.row
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor=0.8
            cell.textLabel?.text = categories[row].category
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        } else if(segmentedControl.selectedSegmentIndex == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier(InterfaceBuilderInfo.CellIdentifiers.historyCell, forIndexPath: indexPath)

            let row = indexPath.row
            cell.textLabel?.text = locations[row].valueForKey("location") as? String
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(segmentedControl.selectedSegmentIndex == 1) {
            searchResults.removeAll(keepCapacity: false)
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            searchResults = dataRepo.getAllCDThoughtsForAttributeValue((cell?.textLabel?.text)!, attribute: EntityInfo.Thought.categoryString)
            actionAfterSearchCriteriaSelection((cell?.textLabel?.text)!)
        } else if (segmentedControl.selectedSegmentIndex == 2) {
            searchResults.removeAll(keepCapacity: false)
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            searchResults = dataRepo.getAllCDThoughtsForAttributeValue((cell?.textLabel?.text)!, attribute: EntityInfo.Thought.location)
            actionAfterSearchCriteriaSelection((cell?.textLabel?.text)!)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == InterfaceBuilderInfo.SeguePath.goToSearchResults) {
            let destinationVC = segue.destinationViewController as! SearchResultsTableViewController;
            destinationVC.returnedSearchResults = self.searchResults
        }
    }
    
    
    @IBAction func searchByKeywordButtonPressed(sender: AnyObject) {
        //FYI - selection of other cells is disabled at this point. User can just scroll the table
        searchButton.enabled = false
        hideNonSearchViews(true)
        
        holderView = UIView(frame: self.view.frame)
        holderView.backgroundColor = UIColor.grayColor()
        holderView.alpha = 0.4
        self.view.addSubview(holderView)
        
        let screenWidth : CGFloat = self.view.frame.size.width
        let customViewWidth : CGFloat = screenWidth - 30
        
        let navigationBarY = self.navigationController?.navigationBar.frame.origin.y
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        let customViewY : CGFloat = navigationBarY! + navigationBarHeight! + 5
        self.customView =  SearchByKeyword(frame: CGRectMake((screenWidth-customViewWidth)/2, customViewY, customViewWidth, 125))
        self.customView.layer.borderWidth = 0.8
        self.customView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.customView.layer.cornerRadius = 10
        self.customView.clipsToBounds = true

        //self.customView.saveButton.enabled = false
        self.customView.cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.customView.saveButton.addTarget(self, action: "searchButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.customView!);
    }
    
    func cancelButtonTapped(sender:UIButton!) {
        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        hideNonSearchViews(false)
        searchButton.enabled = true
    }
    
    func searchButtonTapped(sender:UIButton!) {
        let finalKEYWORDS = self.customView.keywordInput.text
        
        if(StringUtils.isBlank(finalKEYWORDS)) {
            let alert = UIAlertController(title: "Error", message: "The search criteria was empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {})
        } else {
            //SEARCH
            searchResults.removeAll(keepCapacity: false)
            searchResults = dataRepo.getCDThoughtsByKeywords(finalKEYWORDS!)
            actionAfterSearchCriteriaSelection("'"+finalKEYWORDS!+"'")
        }

        self.customView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        hideNonSearchViews(false)
        searchButton.enabled = true
    }
    
    func hideNonSearchViews(hide : Bool) {
        if(hide) {
            segmentedControl.hidden = true
            calendarPlaceholderView.hidden = true
            tableView.hidden = true
            moodBaseView.hidden = true
        } else {
            segmentedControl.hidden = false
            if(segmentedControl.selectedSegmentIndex == 1 || segmentedControl.selectedSegmentIndex == 2) {
                setupTableView()
            } else if(segmentedControl.selectedSegmentIndex == 3) {
                setupMoodView()
            } else {
                setupCalendarView()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
