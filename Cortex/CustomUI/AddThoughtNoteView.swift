//
//  AddThoughtNoteView.swift
//  Coretx
//
//  Created by Manisha Yeramareddy on 03/16/16.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//


import UIKit

@IBDesignable class AddThoughtNoteView : UIView {
    
    var view : UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var textFieldView: UITextView!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
   @IBInspectable var lblTitleText : String? {
        get {
            return titleLabel.text
        }
        set(lblTitleText) {
            titleLabel.text = lblTitleText!
        }
    }
    
    @IBInspectable var textFieldViewText : String? {
        get {
            return textFieldView.text
        }
        set(textFieldViewText) {
            textFieldView.text = textFieldViewText!
        }
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
        let nib = UINib(nibName: "AddThoughtNoteView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view)
    }

    
}