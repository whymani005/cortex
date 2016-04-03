//
//  DrawSettingsView.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/18/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//


import UIKit

@IBDesignable class DrawSettingsView : UIView {
    
    var view:UIView!
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var settingsHeader: UILabel!
    @IBOutlet weak var widthSlider: UISlider!
    
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacitySlider: UISlider!
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //*********************************************** WIDTH SLIDER VALUES
    
    @IBInspectable var widthSliderValue : Float? {
        get {
            return widthSlider.value;
        }
        set(widthSliderValue) {
            widthSlider.value = widthSliderValue!;
        }
    }
    
    //*********************************************** RGB SLIDER VALUES
    
    @IBInspectable var redSliderValue : Float? {
        get {
            return redSlider.value;
        }
        set(redSliderValue) {
            redSlider.value = redSliderValue!;
        }
    }
    
    @IBInspectable var greenSliderValue : Float? {
        get {
            return greenSlider.value;
        }
        set(greenSliderValue) {
            greenSlider.value = greenSliderValue!;
        }
    }
    
    @IBInspectable var blueSliderValue : Float? {
        get {
            return blueSlider.value;
        }
        set(blueSliderValue) {
            blueSlider.value = blueSliderValue!;
        }
    }
    
    //*********************************************** RGB  TEXT VALUES
    
    @IBInspectable var redValueText : String? {
        get {
            return redValue.text;
        }
        set(redValueText) {
            redValue.text = redValueText!;
        }
    }
    
    @IBInspectable var greenValueText : String? {
        get {
            return greenValue.text;
        }
        set(greenValueText) {
            greenValue.text = greenValueText!;
        }
    }
    
    @IBInspectable var blueValueText : String? {
        get {
            return blueValue.text;
        }
        set(blueValueText) {
            blueValue.text = blueValueText!;
        }
    }
    
    //*********************************************** INIT FUNCs
    
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
        let nib = UINib(nibName: "DrawSettingsView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);

    }

    
}