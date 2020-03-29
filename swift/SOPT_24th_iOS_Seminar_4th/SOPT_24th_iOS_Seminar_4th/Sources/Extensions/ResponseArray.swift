//
//  ResponseArray.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import ObjectMapper

struct ResponseArray<T: Mappable>: Mappable {
    
    var status: Int?
    var success: Bool?
    var message: String?
    var data: [T]? // data 배열 generic
    
    init?(map: Map) {}
    
    
    /*
        json 에서 받은 data를 여기의 변수에 넣음.
     */
    mutating func mapping(map: Map) {
        status <- map["status"]
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
}
