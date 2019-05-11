//
//  ResponseObject.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import ObjectMapper

struct ResponseObject<T: Mappable>: Mappable {
    
    var status: Int?
    var success: Bool?
    var message: String?
    var data: T?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
}
