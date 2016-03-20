//
//  ForgotPasswordViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 12/27/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        //recoverPasswordButton.enabled = false

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldChanged:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        emailInput.becomeFirstResponder()
    }
    
    func textFieldChanged(sender: NSNotification) {
        setButtonBasedOnInput()
    }
    
    func setButtonBasedOnInput() {
        let isEmailInputEmpty = StringUtils.isBlank(emailInput.text)
        let isEmailValidFormat = StringUtils.isEmailAddressValid(emailInput.text)
        
        if(!isEmailInputEmpty && isEmailValidFormat) {
            recoverPasswordButton.setImage(UIImage(named:"loginCheckFilled.png"),forState:UIControlState.Normal)
            recoverPasswordButton.enabled = true
        } else {
            recoverPasswordButton.setImage(UIImage(named:"loginCheck.png"),forState:UIControlState.Normal)
            recoverPasswordButton.enabled = false
        }
    }

    @IBAction func recoverPasswordButtonPressed(sender: AnyObject) {
        if(ConnectionUtils.connectedToNetwork()) {
            // convert the email string to lower case
            //let cleanEmail = emailInput.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            //recovver password
        } else {
            let alert = UIAlertController(title: "Error", message: "The Internet connection appears to be offline. Please check your connection and try again", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {})
        }
    }
    
    func pause(){
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func restore(){
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    

}
