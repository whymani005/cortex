//
//  SimpleCustomView.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 12/31/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//


import UIKit

@IBDesignable class ShowQuoteView : UIView {
    
    var view:UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var detailView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    @IBInspectable var detailText : String? {
        get {
            return detailView.text
        }
        set(detailText) {
            detailView.text = detailText!
        }
    }
    
    @IBInspectable var authorText : String? {
        get {
            return authorLabel.text
        }
        set(authorText) {
            authorLabel.text = authorText!
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
        let nib = UINib(nibName: "ShowQuoteView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

    
}