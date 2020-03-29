//
//  CommentTVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by Sunghee Lee on 25/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class CommentTVC: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var thumbnailImg: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.setBorder(borderColor: UIColor.veryLightPinkThree, borderWidth: 1.0)
        thumbnailImg.setBorder(borderColor: UIColor.veryLightPinkThree, borderWidth: 1.0)
        
        commentLabel.numberOfLines = 0
        commentLabel.text = "가변적으로 변하는 Label 의 numberOfLines"
        commentLabel.sizeToFit()
        
        nameLabel.sizeToFit()
        dateLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
