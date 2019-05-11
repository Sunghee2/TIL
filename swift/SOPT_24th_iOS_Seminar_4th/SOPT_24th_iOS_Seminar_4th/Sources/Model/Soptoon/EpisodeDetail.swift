//
//  EpisodeDetail.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 10/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import ObjectMapper

struct EpisodeDetail: Mappable {
    var epInfo: [EpisodeInfo]?
    var epImgs: [String]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        epInfo <- map["epInfo"]
        epImgs <- map["imgs"]
    }
    
}

struct EpisodeInfo: Mappable {
    var chapter: Int?
    var title: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        chapter <- map["chapter"]
        title <- map["title"]
    }
}
