//
//  SearchByKeyword.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 12/29/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//


import UIKit

@IBDesignable class SearchByKeyword : UIView {
    var view:UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var keywordInput: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBInspectable var lblTitleText : String? {
        get {
            return lbTitle.text;
        }
        set(lblTitleText) {
            lbTitle.text = lblTitleText!;
        }
    }
    
    @IBInspectable var newWordText : String? {
        get {
            return keywordInput.text;
        }
        set(newWordText) {
            keywordInput.text = newWordText!;
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
        let nib = UINib(nibName: "SearchByKeyword", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
}