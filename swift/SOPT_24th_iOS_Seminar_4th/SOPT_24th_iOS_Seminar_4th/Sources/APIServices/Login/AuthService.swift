//
//  LoginService.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Alamofire

struct AuthService: APIManager, Requestable {
    
    typealias NetworkData = ResponseString
    static let shared = AuthService()
    let AuthURL = url("/auth") // APIManager extension의 url 사용함
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json"
    ]
    
    // 로그인 api
    func signin(id: String, password: String, completion: @escaping (ResponseString) -> Void) {
        
        let queryURL = AuthURL + "/signin"
        
        let body = [
            "id" : id,
            "password" : password
        ]
        
        /*
            Requestable extension
            postable 파라미터 중 마지막 함수(header)를 {} 속에서 구현하고 있음
         */
        postable(queryURL, body: body, header: headers) { res in
            switch res {
            case .success(let value):
                
                print("######### success #########")
                print(value)
                print("######### success #########")
                
                completion(value)
            case .error(let error):
                
                print("######### error #########")
                print(error)
                print("######### error #########")
            }
        }
    }
    
    // 회원가입 api
    func signup(id: String, password: String, name: String, completion: @escaping (ResponseString) -> Void) {
        
        let queryURL = AuthURL + "/signup"
        
        let body = [
            "id" : id,
            "password" : password,
            "name" : name
        ]
        
        /*
         Requestable extension
         postable 파라미터 중 마지막 함수(header)를 {} 속에서 구현하고 있음
         */
        postable(queryURL, body: body, header: headers) { res in
            switch res {
            case .success(let value):
                
                print("######### success #########")
                print(value)
                print("######### success #########")
                
                completion(value)
            case .error(let error):
                
                print("######### error #########")
                print(error)
                print("######### error #########")
            }
        }
    }

}
