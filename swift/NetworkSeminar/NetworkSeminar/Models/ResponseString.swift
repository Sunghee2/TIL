//
//  ResponseString.swift
//  NetworkSeminar
//
//  Created by wookeon on 29/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

// codable 은 swift 에서 채택한 default 모델입니다.
// object mapper 를 사용할 필요가 없습니다.
struct ResponseString: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: String?
}
