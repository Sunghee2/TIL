//
//  SoptoonInfo.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import ObjectMapper

struct SoptoonInfo: Mappable {
    
    var title: String?
    var likes: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        likes <- map["likes"]
    }
}
