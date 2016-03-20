//
//  DayCollectionCell.swift
//  Calendar
//
//  Created by Lancy on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

class DayCollectionCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var markedView: UIView!
    @IBOutlet var markedViewWidth: NSLayoutConstraint!
    @IBOutlet var markedViewHeight: NSLayoutConstraint!

    var date: Date? {
        didSet {
            if date != nil {
                label.text = "\(date!.day)"
                if(isDateToday(date)) {
                    label.textColor = UIColor.redColor()
                } else {
                    label.textColor = UIColor.blackColor()
                }
            } else {
                label.text = ""
            }
        }
    }
    
    func isDateToday(givenDate : Date?) -> Bool {
        if(givenDate == nil) {
            return false
        }
        let today = NSDate()
        if( (today.day != givenDate!.day) || (today.month != givenDate!.month) || (today.year != givenDate!.year) ) {
            return false
        }
        
        return true
    }
    
    var disabled: Bool = false {
        didSet {
            if disabled {
                alpha = 0.4
            } else {
                alpha = 1.0
            }
        }
    }
    
    var mark: Bool = false {
        didSet {
            if mark {
                markedView!.hidden = false
            } else {
                markedView!.hidden = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        markedViewWidth!.constant = min(self.frame.width, self.frame.height)
        markedViewHeight!.constant = min(self.frame.width, self.frame.height)
        markedView!.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2.0
    }

}
