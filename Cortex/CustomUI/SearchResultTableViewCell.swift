//
//  SearchResultTableViewCell.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/5/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var thoughtContent: UILabel!
    
    var moodInt : Int = 4

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.cardSetup()
        
    }
    
    func cardSetup() {
        
        self.cardView.frame = CGRectMake(0, 5, frame.width, frame.height)
        self.cardView.alpha = 1
        self.cardView.layer.masksToBounds = true
        self.backgroundColor = UIColor(rgba: "#E0E0E0") //UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }

}
