//
//  DoodleViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/3/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

protocol DoodleDelegate {
    func attachDoodleImage(doodleImage: UIImage)
}

class DoodleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var doodleDelegateVar : DoodleDelegate?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var doodleSettingsButton: UIBarButtonItem!
    @IBOutlet weak var drawView: UIImageView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var pinDrawingButton: UIBarButtonItem!
    
    var holderView : UIView!
    var customDrawSettingsView : DrawSettingsView!
    
    var lastPoint : CGPoint!
    var isSwiping : Bool!
    var isSettingsViewShown : Bool = false
    
    var brushWidth : CGFloat = 4.0
    var tempWidth : CGFloat = 4.0
    
    var opacity : CGFloat = 1.0
    var tempOpacity : CGFloat = 1.0
    
    //0 to 1 value
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var tempRed: CGFloat = 0.0
    var tempGreen: CGFloat = 0.0
    var tempBlue: CGFloat = 0.0

    var red255: Float = 0.0
    var green255: Float = 0.0
    var blue255: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.contentMode = .ScaleAspectFit
        //undoButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        drawView.contentMode = .ScaleAspectFit
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print("touchesBegan")
        if(!isSettingsViewShown) {
            isSwiping  = false
            if let touch = touches.first as UITouch! {
                lastPoint = touch.locationInView(drawView)
            }
        }
    }
    
    //DETECTS LINES
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!isSettingsViewShown) {
            //print("touchesMoved")
            isSwiping = true
            let undo: UIImageView = undoManager?.prepareWithInvocationTarget(self.drawView) as! UIImageView
            
            if let touch = touches.first as UITouch! {
                let currentPoint = touch.locationInView(drawView)
                UIGraphicsBeginImageContext(self.drawView.frame.size)
                self.drawView.image?.drawInRect(CGRectMake(0, 0, self.drawView.frame.size.width, self.drawView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext(),CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brushWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, opacity)
                CGContextStrokePath(UIGraphicsGetCurrentContext())
                if(self.drawView != nil && self.drawView.image != nil) {
                    undo.image = self.drawView.image!
                } else {
                    undo.image = nil
                }
                self.drawView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                lastPoint = currentPoint
            }
        } 
    }
    
    //DETECTS DOTS
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!isSettingsViewShown) {
            if(!isSwiping) {
                //print("touchesEnded")
                let undo: UIImageView = undoManager?.prepareWithInvocationTarget(self.drawView) as! UIImageView

                UIGraphicsBeginImageContext(self.drawView.frame.size)
                self.drawView.image?.drawInRect(CGRectMake(0, 0, self.drawView.frame.size.width, self.drawView.frame.size.height))
                CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brushWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity)
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
                CGContextStrokePath(UIGraphicsGetCurrentContext())
                if(self.drawView != nil && self.drawView.image != nil) {
                    undo.image = self.drawView.image!
                } else {
                    undo.image = nil
                }
                self.drawView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
    }
  
    @IBAction func undoButtonPressed(sender: AnyObject) {
        if(self.drawView != nil && self.drawView.image != nil) {
            undoManager?.undo()
        }
    }
    
    @IBAction func drawSettingsButtonPressed(sender: AnyObject) {
        isSettingsViewShown = true
        doodleSettingsButton.enabled = false
        pinDrawingButton.enabled = false
        
        holderView = UIView(frame: self.view.frame)
        holderView.backgroundColor = UIColor.grayColor()
        holderView.alpha = 0.4
        self.view.addSubview(holderView)
        
        let screenWidth : CGFloat = self.view.frame.size.width
        let customViewWidth : CGFloat = screenWidth - 30 //300
        
        let navigationBarY = self.navigationController?.navigationBar.frame.origin.y
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        let customViewY : CGFloat = navigationBarY! + navigationBarHeight! + 5
        customDrawSettingsView = DrawSettingsView(frame: CGRectMake((screenWidth-customViewWidth)/2, customViewY, customViewWidth, 326))
        customDrawSettingsView.layer.borderWidth = 0.8
        customDrawSettingsView.layer.borderColor = UIColor.lightGrayColor().CGColor
        customDrawSettingsView.layer.cornerRadius = 10
        customDrawSettingsView.clipsToBounds = true
        
        initDrawSettingsWithPreviousValues()
        
        self.customDrawSettingsView.widthSlider.addTarget(self, action: #selector(DoodleViewController.widthSliderChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.customDrawSettingsView.opacitySlider.addTarget(self, action: #selector(DoodleViewController.opacitySliderChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.customDrawSettingsView.redSlider.addTarget(self, action: #selector(DoodleViewController.redSliderChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.customDrawSettingsView.greenSlider.addTarget(self, action: #selector(DoodleViewController.greenSliderChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.customDrawSettingsView.blueSlider.addTarget(self, action: #selector(DoodleViewController.blueSliderChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.customDrawSettingsView.cancelButton.addTarget(self, action: #selector(DoodleViewController.cancelSettingsButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.customDrawSettingsView.okButton.addTarget(self, action: #selector(DoodleViewController.saveSettingsButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.customDrawSettingsView!)
    }
    
    func initDrawSettingsWithPreviousValues () {
        customDrawSettingsView.colorView.layer.borderColor = UIColor.grayColor().CGColor
        customDrawSettingsView.colorView.layer.borderWidth = 0.1;
        
        customDrawSettingsView.widthSlider.value = Float(brushWidth)
        customDrawSettingsView.opacitySlider.value = Float(opacity)
        
        customDrawSettingsView.redSlider.value = red255
        customDrawSettingsView.greenSlider.value = green255
        customDrawSettingsView.blueSlider.value = blue255
        
        customDrawSettingsView.redValue.text = NSNumberFormatter().stringFromNumber(red255)
        customDrawSettingsView.greenValue.text = NSNumberFormatter().stringFromNumber(green255)
        customDrawSettingsView.blueValue.text = NSNumberFormatter().stringFromNumber(blue255)
        
        customDrawSettingsView.colorView.backgroundColor = UIColor(red: tempRed, green: tempGreen, blue: tempBlue, alpha: opacity)
    }
    
    func widthSliderChanged(sender: UISlider) {
        tempWidth = CGFloat(sender.value)
        customDrawSettingsView.colorView.frame = CGRectMake(customDrawSettingsView.colorView.frame.origin.x, customDrawSettingsView.colorView.frame.origin.y, customDrawSettingsView.colorView.frame.width, tempWidth)
    }
    
    func opacitySliderChanged(sender: UISlider) {
        tempOpacity = CGFloat(sender.value)
        customDrawSettingsView.colorView.backgroundColor = UIColor(red: tempRed, green: tempGreen, blue: tempBlue, alpha: tempOpacity)
    }
    
    func redSliderChanged(sender: UISlider) {
        tempRed = CGFloat(sender.value/255.0)
        customDrawSettingsView.redValue.text = NSNumberFormatter().stringFromNumber(sender.value)
        customDrawSettingsView.colorView.backgroundColor = UIColor(red: tempRed, green: tempGreen, blue: tempBlue, alpha: tempOpacity)
        red255 = (sender.value)
    }
    
    func greenSliderChanged(sender: UISlider) {
        tempGreen = CGFloat(sender.value/255.0)
        customDrawSettingsView.greenValue.text = NSNumberFormatter().stringFromNumber(sender.value)
        customDrawSettingsView.colorView.backgroundColor = UIColor(red: tempRed, green: tempGreen, blue: tempBlue, alpha: tempOpacity)
        green255 = (sender.value)
    }
    
    func blueSliderChanged(sender: UISlider!) {
        tempBlue = CGFloat(sender.value/255.0)
        customDrawSettingsView.blueValue.text = NSNumberFormatter().stringFromNumber(sender.value)
        customDrawSettingsView.colorView.backgroundColor = UIColor(red: tempRed, green: tempGreen, blue: tempBlue, alpha: tempOpacity)
        blue255 = (sender.value)
    }
    
    func cancelSettingsButtonTapped(sender:UIButton!) {
        self.customDrawSettingsView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        isSettingsViewShown = false
        doodleSettingsButton.enabled = true
        pinDrawingButton.enabled = true
    }
    
    func saveSettingsButtonTapped(sender:UIButton!) {
        self.customDrawSettingsView.removeFromSuperview()
        self.holderView.removeFromSuperview()
        isSettingsViewShown = false
        doodleSettingsButton.enabled = true
        pinDrawingButton.enabled = true
        
        brushWidth = tempWidth
        opacity = tempOpacity
        red = tempRed
        green = tempGreen
        blue = tempBlue
    }
    
    
    @IBAction func clearDrawingButtonPressed(sender: AnyObject) {
        drawView.image = nil
    }
    
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        imagePicker.editing = false
        imagePicker.delegate = self
        let optionsMenu = UIAlertController(title: nil, message: "Image to Draw On", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imagePicker.navigationBar.backgroundColor = UIColor(rgba: "#DB3C41")
            self.imagePicker.navigationBar.tintColor = UIColor.darkGrayColor()
            self.imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGrayColor()]
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let cameraButton = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) { (alert) -> Void in
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            optionsMenu.addAction(cameraButton)
        } else {
            print("Camera not available")
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        }
        
        optionsMenu.addAction(libButton)
        optionsMenu.addAction(cancelButton)
        
        self.presentViewController(optionsMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        drawView.image = nil
        drawView.image = photo
        drawView.contentMode = .ScaleAspectFit
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func saveDrawingButtonPressed(sender: AnyObject) {
        if(drawView.image != nil) {
            self.doodleDelegateVar?.attachDoodleImage(drawView.image!)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
