//
//  EpisodeList.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import ObjectMapper

struct EpisodeList: Mappable {
    
    var idx: Int?
    var chapter: Int?
    var title: String?
    var thumbnail: String?
    var hits: Int?
    var stIdx: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        idx <- map["idx"]
        chapter <- map["chapter"]
        title <- map["title"]
        thumbnail <- map["thumnail"]
        hits <- map["hits"]
        stIdx <- map["wtIdx"]
    }
}
