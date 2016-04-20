    //
//  WeekHeaderView.swift
//  Calendar
//
//  Created by Lancy on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

class WeekHeaderView: UICollectionReusableView {

    @IBOutlet var labels: [UILabel]!
    
    let formatter = NSDateFormatter()
    
    override func awakeFromNib() {
        if labels.count == formatter.weekdaySymbols.count {
            for i in 0 ..< formatter.weekdaySymbols.count {
                let weekDayString = formatter.weekdaySymbols[i]

                let index: String.Index = weekDayString.startIndex.advancedBy(3)
                labels[i].text = weekDayString.substringToIndex( index ).uppercaseString
                
                //labels[i].text = weekDayString.substringToIndex(advance(weekDayString.startIndex, 3)).uppercaseString 
            }
        }
    }
    
}
