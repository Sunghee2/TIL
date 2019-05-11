//
//  Episode.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import ObjectMapper

struct Episode: Mappable {
   
    var soptoonInfo: SoptoonInfo?
    var list: [EpisodeList]?
    var isLiked: Bool?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        soptoonInfo <- map["webtoonInfo"]
        list <- map["list"]
        isLiked <- map["isLiked"]
    }
}

