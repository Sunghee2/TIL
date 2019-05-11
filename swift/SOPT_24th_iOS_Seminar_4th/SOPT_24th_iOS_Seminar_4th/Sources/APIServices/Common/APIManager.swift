//
//  APIManager.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

protocol APIManager {}

/*
    API Manager는 Base URL + Path 로 요청할 API 의 주소를 만들어준다.
 */
extension APIManager {
    static func url(_ path: String) -> String {
        return "http://hyunjkluz.ml:2424/api" + path
    }
}
