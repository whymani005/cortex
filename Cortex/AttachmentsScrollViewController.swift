//
//  AttachmentsScrollViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/3/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

protocol AttachmentDelegate {
    func attachmentVCDismissed(attachments: [UIImage])
}

class AttachmentsScrollViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DoodleDelegate {
    
    var attachmentDelegateVar : AttachmentDelegate?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var removeImageButton: UIButton!
    @IBOutlet weak var noAttachmentsLabel: UILabel!
    @IBOutlet weak var addNewAttButton: UIBarButtonItem!
    @IBOutlet weak var displayImageView: UIImageView!
    
    var pageImages: [UIImage] = []
    
    var currentPageSelection : Int = -1
    var startingPagesScrollViewSize = CGSize()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        refreshScrollView()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshScrollView()
        resetView(pageImages.count)
        if(pageImages.count >= InterfaceBuilderInfo.Constants.MAX_ATT_PER_THOUGHT) {
           addNewAttButton.enabled = false
        } else {
            addNewAttButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.attachmentDelegateVar?.attachmentVCDismissed(pageImages)
    }
    
    func resetView (count : Int) {
        if(count <= 0) {
            removeImageButton.hidden = true
            noAttachmentsLabel.hidden = false
            scrollView.hidden = true
            displayImageView.hidden = true
        } else {
            removeImageButton.hidden = false
            noAttachmentsLabel.hidden = true
            scrollView.hidden = false
            displayImageView.hidden = false
            scrollView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    @IBAction func addAttachmentsButtonHit(sender: AnyObject) {
        imagePicker.editing = false
        imagePicker.delegate = self
        let optionsMenu = UIAlertController(title: nil, message: "Attachment Options", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imagePicker.navigationBar.backgroundColor = UIColor(rgba: "#DB3C41")
            self.imagePicker.navigationBar.tintColor = UIColor.darkGrayColor()
            self.imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGrayColor()]
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) { (alert) -> Void in
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            optionsMenu.addAction(cameraButton)
        } else {
            print("Camera not available")
        }
        let doodleButton = UIAlertAction(title: "Custom Doodle", style: UIAlertActionStyle.Default) { (alert) -> Void in
            self.performSegueWithIdentifier(InterfaceBuilderInfo.SeguePath.showDoodleViewSegue, sender: self)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        }
        
        optionsMenu.addAction(libButton)
        optionsMenu.addAction(doodleButton)
        optionsMenu.addAction(cancelButton)
        
        self.presentViewController(optionsMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        pageImages.append(photo!)
        refreshScrollView()
    }
    
    @IBAction func removeImageButtonPressed(sender: AnyObject) {
        
        pageImages.removeAtIndex(currentPageSelection)
        
        refreshScrollView()
        
        if(pageImages.count >= InterfaceBuilderInfo.Constants.MAX_ATT_PER_THOUGHT) {
            addNewAttButton.enabled = false
        } else {
            addNewAttButton.enabled = true
        }
    }
    
    func refreshScrollView() {
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        loadVisiblePages()
        
        resetView(pageCount)
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        displayImageView.image = pageImages[page]
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        currentPageSelection = page
        
        // Update the page control
        pageControl.currentPage = page
        
        // Load pages in our range
        loadPage(currentPageSelection)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    //################################################ DELEGATE METHODS ###################################################
    
    func attachDoodleImage(doodleImage: UIImage) {
        pageImages.append(doodleImage)
        refreshScrollView()
    }
    
    //################################################ MEMORY/SEGUE METHODS ###################################################
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destinationViewController as? DoodleViewController {
            viewController.doodleDelegateVar = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
