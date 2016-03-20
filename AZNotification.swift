//
//  AZNotification.swift
//  AZNotificationDemo
//
//  Created by Mohammad Azam on 6/4/14.
//  Copyright (c) 2014 AzamSharp Consulting LLC. All rights reserved.
//

import Foundation
import UIKit


class AZNotification
{
    class func showNotificationWithTitle(title :String, var controller :UIViewController!, notificationType :AZNotificationType)
    {
        if controller.navigationController != nil {
            controller = controller.navigationController
        }
        
        let azNotificationView = AZNotificationView(title: "Success", referenceView: controller.view, notificationType: .Success)

        controller.view.addSubview(azNotificationView)
        azNotificationView.applyDynamics()
    }
    
    class func showNotificationWithTitle(title :String, controller :UIViewController, notificationType :AZNotificationType, shouldShowNotificationUnderNavigationBar :Bool)
    {
        let azNotificationView = AZNotificationView(title: title, referenceView: controller.view, notificationType: notificationType, showNotificationUnderNavigationBar: shouldShowNotificationUnderNavigationBar)
        
        controller.view.addSubview(azNotificationView)
        azNotificationView.applyDynamics()
    }
 
        
    
}