//
//  File.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 4/20/16.
//  Copyright © 2016 Manisha Yeramareddy. All rights reserved.
//

import Foundation


class CategoryListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let dataRepo = DataRepository()
    var chosenCategoryString = ""
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRepo.getAllCategories().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(InterfaceBuilderInfo.CellIdentifiers.changeCategoryCell)
        if(cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: InterfaceBuilderInfo.CellIdentifiers.changeCategoryCell)
        }
        
        cell!.textLabel?.adjustsFontSizeToFitWidth = true
        cell!.textLabel?.minimumScaleFactor = 0.8
        cell!.textLabel?.text = dataRepo.getAllCategories()[indexPath.row].category
        cell!.textLabel?.textAlignment = NSTextAlignment.Center

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        
        /*var cell = tableView.dequeueReusableCellWithIdentifier(InterfaceBuilderInfo.CellIdentifiers.changeCategoryCell)
        cell!.accessoryType = .Checkmark
        //checked[indexPath.row] = true*/
        
        chosenCategoryString = dataRepo.getAllCategories()[indexPath.row].category!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    
    
}