//
//  WebtoonCVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class SoptoonCVC: UICollectionViewCell {

    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       view.setBorder(borderColor: UIColor.veryLightPinkThree, borderWidth: 1.0)
        thumbImg.setBorder(borderColor: UIColor.veryLightPinkThree, borderWidth: 1.0)
        
        titleLabel.sizeToFit()
        authorLabel.sizeToFit()
    }

}
