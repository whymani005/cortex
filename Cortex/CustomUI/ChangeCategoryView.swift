//
//  ChangeCategoryView.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 04/18/16.
//  Copyright © 2016 Manisha Yeramareddy. All rights reserved.
//


import UIKit

@IBDesignable class ChangeCategoryView : UIView {
    
    var view: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBInspectable var lblTitleText : String? {
        get {
            return lblTitle.text;
        }
        set(lblTitleText) {
            lblTitle.text = lblTitleText!;
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
        let nib = UINib(nibName: "ChangeCategoryView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view)
    }

}
