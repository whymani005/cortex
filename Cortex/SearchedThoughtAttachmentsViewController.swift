//
//  SearchedThoughtAttachmentsViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 12/5/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

protocol ShowThoughtAttachmentDelegate {
    func showThoughtattachmentVCDismissed(attachments: [UIImage])
}

class SearchedThoughtAttachmentsViewController: UIViewController, UIScrollViewDelegate {
    
    var showThoughtAttachmentDelegateVar : ShowThoughtAttachmentDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var displayImageView: UIImageView!
    
    var pageImages: [UIImage] = []
    var currentPageSelection : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshScrollView()

        // Do any additional setup after loading the view.
    }
    
    func resetView (count : Int) {
        if(count <= 0) {
            scrollView.hidden = true
        } else {
            scrollView.hidden = false
            //scrollView.backgroundColor = UIColor.whiteColor()
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
            print("OUTSIDE THE RANGE!!")
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

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
