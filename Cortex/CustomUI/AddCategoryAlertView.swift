//
//  AddCategoryAlertView.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/18/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//


import UIKit

@IBDesignable class AddCategoryAlertView : UIView {
    
    var view:UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var categoryInput: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var middleDividerView: UIView!
    
    @IBInspectable var lblTitleText : String? {
        get {
            return lblTitle.text;
        }
        set(lblTitleText) {
            lblTitle.text = lblTitleText!;
        }
    }
    
    @IBInspectable var newCatText : String? {
        get {
            return categoryInput.text;
        }
        set(newCatText) {
            categoryInput.text = newCatText!;
        }
    }
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
    }
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddCategoryAlertView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

    
}