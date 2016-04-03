//
//  MyStringItemSource.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 4/2/16.
//  Copyright © 2016 Manisha Yeramareddy. All rights reserved.
//

import Foundation

class MyStringItemSource: NSObject, UIActivityItemSource {
    
    @objc func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return ""
    }
    
    @objc func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        if activityType == UIActivityTypeMessage {
            return "String for message"
        } else if activityType == UIActivityTypeMail {
            return "String for mail"
        } else if activityType == UIActivityTypePostToTwitter {
            return "String for twitter"
        } else if activityType == UIActivityTypePostToFacebook {
            return "String for facebook"
        }
        return nil
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        if activityType == UIActivityTypeMessage {
            return "Subject for message"
        } else if activityType == UIActivityTypeMail {
            return "Subject for mail"
        } else if activityType == UIActivityTypePostToTwitter {
            return "Subject for twitter"
        } else if activityType == UIActivityTypePostToFacebook {
            return "Subject for facebook"
        }
        return ""
    }
    
    func activityViewController(activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: String?, suggestedSize size: CGSize) -> UIImage? {
        if activityType == UIActivityTypeMessage {
            return UIImage(named: "thumbnail-for-message")
        } else if activityType == UIActivityTypeMail {
            return UIImage(named: "thumbnail-for-mail")
        } else if activityType == UIActivityTypePostToTwitter {
            return UIImage(named: "thumbnail-for-twitter")
        } else if activityType == UIActivityTypePostToFacebook {
            return UIImage(named: "thumbnail-for-facebook")
        }
        return UIImage(named: "some-default-thumbnail")
    }
    
}