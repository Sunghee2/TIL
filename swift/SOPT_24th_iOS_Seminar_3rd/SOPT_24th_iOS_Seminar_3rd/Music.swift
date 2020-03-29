//
//  Music.swift
//  SOPT_24th_iOS_Seminar_3rd
//
//  Created by wookeon on 26/04/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Foundation
import UIKit

// Music 모델입니다.
// 멤버 변수가 총 세 개인 Music 구조체를 생성했습니다.
struct Music {
    var albumImg: UIImage?
    var musicTitle: String
    var singer: String
    
    init(title: String, singer: String, coverName: String) {
        self.albumImg = UIImage(named: coverName)
        self.musicTitle = title
        self.singer = singer
    }
}
