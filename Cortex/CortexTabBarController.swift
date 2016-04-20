//
//  CortexTabBarController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import UIKit

class CortexTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change color of the bar
        UITabBar.appearance().barTintColor = UIColor(rgba: "#f6f6f6")

        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Selected)
        
        var i = 0
        for item in (self.tabBar.items as [UITabBarItem]?)! {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor(rgba: "#775566")).imageWithRenderingMode(.AlwaysOriginal)
            }
            if let selectedImage = item.selectedImage {
                var finalImage = selectedImage
                if(i == 0) {
                    if let finalImage0 = UIImage(named:"PersonThoughtFilled.png") {
                        finalImage = finalImage0 //DB3C41
                        item.selectedImage = finalImage.imageWithColor(UIColor.darkGrayColor()).imageWithRenderingMode(.AlwaysOriginal)
                    }
                } else if(i == 1) {
                    if let finalImage0 = UIImage(named: "FilingCabinetFilled.png") {
                        finalImage = finalImage0 //3CB3B5
                        item.selectedImage = finalImage.imageWithColor(UIColor.darkGrayColor()).imageWithRenderingMode(.AlwaysOriginal)
                    }
                } else if(i == 2) {
                    if let finalImage0 = UIImage(named: "TrendsFilled.png") {
                        finalImage = finalImage0 //35AE4A
                        item.selectedImage = finalImage.imageWithColor(UIColor.darkGrayColor()).imageWithRenderingMode(.AlwaysOriginal)
                    }
                } else {
                    item.selectedImage = finalImage.imageWithColor(UIColor(rgba:"#775566")).imageWithRenderingMode(.AlwaysOriginal) //#ee9977
                }
            }
            i += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


