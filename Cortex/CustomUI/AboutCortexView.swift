//
//  AboutCortexView.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 12/31/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//


import UIKit

@IBDesignable class AboutCortexView : UIView {
    
    var view:UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var versionLable: UILabel!
    @IBOutlet weak var termsOfUseButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var infoView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    
    @IBInspectable var lblTitleText : String? {
        get {
            return lblTitle.text;
        }
        set(lblTitleText) {
            lblTitle.text = lblTitleText!
        }
    }
    
    @IBInspectable var versionText : String? {
        get {
            return versionLable.text;
        }
        set(versionText) {
            versionLable.text = versionText!
        }
    }
    
    @IBInspectable var infoText : String? {
        get {
            return infoView.text;
        }
        set(versionText) {
            infoView.text = infoText!
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
        let nib = UINib(nibName: "AboutCortexView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        termsOfUseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        privacyPolicyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.addSubview(view);
    }

    
}