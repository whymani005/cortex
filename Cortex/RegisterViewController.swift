//
//  RegisterViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
//import Security

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailInputTextField: UITextField!
    @IBOutlet weak var passwordInputTextField: UITextField!
    @IBOutlet weak var confirmPasswordInputTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var haveAnAccountButton: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let dataRepo = DataRepository()
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.enabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldChanged:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
 
    }
    
    //################################################ HELPER METHODS #####################################################################
    
    func textFieldChanged(sender: NSNotification) {
        let inputEmail = emailInputTextField.text
        let inputPassword = passwordInputTextField.text
        
        if(!StringUtils.isBlank(inputEmail) && !StringUtils.isBlank(inputPassword)) {
            registerButton.setImage(UIImage(named:"loginCheckFilled.png"),forState:UIControlState.Normal)
            registerButton.enabled = true
        } else {
            registerButton.setImage(UIImage(named:"loginCheck.png"),forState:UIControlState.Normal)
            registerButton.enabled = false
        }
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    //################################################ REGISTER LOGIC METHODS ##############################################################
    
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        let email = emailInputTextField.text?.lowercaseString
        let password = passwordInputTextField.text
        let retypePassword = confirmPasswordInputTextField.text
        
        if(StringUtils.isBlank(email) || StringUtils.isBlank(password) || StringUtils.isBlank(retypePassword)) {
            let alert = displayAlertMessage("Error", message: "All fields are required", actionTitle: "OK")
            self.presentViewController(alert, animated: true, completion: nil)
        } else if(!StringUtils.equals(password, optionalTwo: retypePassword)) {
            let alert = displayAlertMessage("Error", message: "Passwords don't match", actionTitle: "OK")
            self.presentViewController(alert,
                animated: true,
                completion: {
                    self.passwordInputTextField.text = ""
                    self.confirmPasswordInputTextField.text = ""}
            )
        } else if(!StringUtils.isEmailAddressValid(email)) {
            let alert = displayAlertMessage("Error", message: "Email address is invalid", actionTitle: "OK")
            self.presentViewController(alert,
                animated: true,
                completion: {
                    self.passwordInputTextField.text = ""
                    self.confirmPasswordInputTextField.text = ""}
            )
        } else {
            //pause()
            
            //let encryptedPass = RNCryptor.encryptData(NSData(), password: password!)
            //Account.createNewAccountInMOC(self.managedObjectContext!, password: encryptedPass, email: email!.lowercaseString, installDate: NSDate())
            //self.dataRepo.save()
            //set user defaults
            //self.setNewUserDefaults(email!)
            //self.resume()
 
        }
    }
    
    func pause() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.view.alpha = 0.6
        registerButton.enabled = false
        haveAnAccountButton.enabled = false
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
    }
    
    func resume() {
        activityIndicatorView.stopAnimating(); activityIndicatorView.hidden = true
        self.registerButton.enabled = true
        self.haveAnAccountButton.enabled = true
        self.view.alpha = 1.0
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    func displayAlertMessage(alertTitle: NSString, message: NSString, actionTitle: NSString) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle as String, message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle as String, style: UIAlertActionStyle.Default, handler: nil))
        return alert
        //self.presentViewController(alert, animated: true, completion: {})
    }
    
    func setNewUserDefaults(userEmail: String) {
        print("setNewUserDefaults for - \(userEmail)")
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: UserInformation.USER_EMAIL)
    }
    
}
