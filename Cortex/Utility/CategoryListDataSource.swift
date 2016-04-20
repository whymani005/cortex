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
    var chosenNewCat = ""
    
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print("didSelectRowAtIndexPath - "+dataRepo.getAllCategories()[indexPath.row].category!)
        chosenNewCat = dataRepo.getAllCategories()[indexPath.row].category!
        //dismissCustomView()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    
    
}