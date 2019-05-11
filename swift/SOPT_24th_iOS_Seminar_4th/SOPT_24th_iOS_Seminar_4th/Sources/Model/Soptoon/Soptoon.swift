//
//  Soptoon.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import ObjectMapper

/*
    model/common/ResponseArray 속 data 안에 들어가는 모델
 */
struct Soptoon: Mappable {
    
    var idx: Int?
    var title: String?
    var thumbnail: String?
    var isFinished: Int?
    var likes: Int?
    var author: String?
    
    init?(map: Map) {}
    
    /*
     구조체나 열거형에서 정의된 메소드가 자기 자신의 인스턴스를 수정하거나 프로퍼티를 변경해야 할 때 mutating 키워드를 사용합니다.
     ex) 현재 위의 idx 변수를 가져와서 바꿈
     대표적으로 extension 이 구조체나 열거형을 확장의 대상으로 삼았을 때가 이에 해당합니다.
     
     지금 이 상황에서는 mapping func 이 자기 자신의 프로퍼티들을 변경하기 때문에 해당 func 에 mutating 키워드가 추가된 경우입니다.
    */
    mutating func mapping(map: Map) {
        idx <- map["idx"]
        title <- map["title"]
        thumbnail <- map["thumnail"]
        isFinished <- map["isFinished"]
        likes <- map["likes"]
        author <- map["name"]
    }
}

