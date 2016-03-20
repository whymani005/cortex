//
//  LoginViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/16/15.
//  Copyright (c) 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var inputBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var loginBoxView: UIView!
    @IBOutlet weak var emailInputTextField: UITextField!
    @IBOutlet weak var passwordInputTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let dataRepo = DataRepository()
    var authenticationError = "Authentication Failed - Unexpected Error"
    var oldUser : String?
    var previousConstant : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        loginButton.enabled = false
        oldUser = NSUserDefaults.standardUserDefaults().stringForKey(UserInformation.USER_EMAIL)
        if(!StringUtils.isBlank(oldUser)) {
            emailInputTextField.text = oldUser
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldChanged:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    //############################################### TEXT KEYBOARD HELPERS ##################################################
    
    func textFieldChanged(sender: NSNotification) {
        let inputEmail = emailInputTextField.text
        let inputPassword = passwordInputTextField.text

        if(!StringUtils.isBlank(inputEmail) && !StringUtils.isBlank(inputPassword)) {
            loginButton.setImage(UIImage(named:"loginCheckFilled.png"),forState:UIControlState.Normal)
            loginButton.enabled = true
        } else {
            loginButton.setImage(UIImage(named:"loginCheck.png"),forState:UIControlState.Normal)
            loginButton.enabled = false
        }
    }
    
    //stackoverflow.com/questions/30667283/swift-ios-move-text-field-when-keyboard-is-shown
    func keyboardWillShow(notification : NSNotification) {
        let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
        previousConstant = self.inputBottomContraint.constant
        self.inputBottomContraint.constant = keyboardSize!.height - CGFloat(25)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        self.inputBottomContraint.constant = previousConstant
        self.view.layoutIfNeeded()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //################################################ LOGIN METHODS #####################################################
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        self.view.alpha = 0.6
        self.view.addSubview(activityIndicatorView)
        
        if (authenticateUser()) {
            //check if this user is same as previous
            NSUserDefaults.standardUserDefaults().setObject(self.emailInputTextField.text, forKey: UserInformation.USER_EMAIL)
            //let newUser = UserUtils.getCurrentUsername()
            //print("old user -- \(oldUser) , new user -- \(newUser)")
                
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.performSegueWithIdentifier(InterfaceBuilderInfo.SeguePath.showCreateNewThoughtView, sender: self)
        } else {
            activityIndicatorView.stopAnimating(); activityIndicatorView.hidden = true
            self.view.alpha = 1.0
            self.passwordInputTextField.text = ""
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Error", message: self.authenticationError, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {})
        }
    }
    
    func authenticateUser() -> Bool {
        
        /*let existingAcct = dataRepo.getAccountByEmail(emailInputTextField.text!.lowercaseString)
        if(existingAcct != nil) {
            do {
                _ = try RNCryptor.decryptData((existingAcct?.password)!, password: passwordInputTextField.text!)
                return true
            } catch {
                print("CD ACCOUNT decrypting error: \(error)")
                authenticationError = "Incorrect email and/or password"
                return false
            }
        }*/
        return false
    }
    

    //############################################ MEMORY MANAGEMENT METHODS ####################################################
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
