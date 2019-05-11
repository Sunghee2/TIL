//
//  Requestable.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

//Request 함수를 재사용하기 위한 프로토콜입니다.
protocol Requestable {
    associatedtype NetworkData: Mappable
}

extension Requestable {
    
    //서버에 get 요청을 보내는 함수
    func gettable(_ url: String, body: [String:Any]?, header: HTTPHeaders?, completion: @escaping (NetworkResult<NetworkData>) -> Void) {
        Alamofire.request(url, method: .get, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseObject { (res: DataResponse<NetworkData>) in
                switch res.result {
                case .success:
                    guard let value = res.result.value else { return }
                    completion(.success(value))
                case .failure(let err):
                    completion(.error(err))
                }
        }
    }
    
    //서버에 post 요청을 보내는 함수
    func postable(_ url: String, body: [String:Any]?, header: HTTPHeaders?, completion: @escaping (NetworkResult<NetworkData>) -> Void) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseObject { (res: DataResponse<NetworkData>) in
                switch res.result {
                case .success:
                    guard let value = res.result.value else { return }
                    completion(.success(value))
                case .failure(let err):
                    completion(.error(err))
                }
        }
    }
    
    func putable(_ url: String, body: [String:Any]?, header: HTTPHeaders?, completion: @escaping (NetworkResult<NetworkData>) -> Void) {
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseObject { (res: DataResponse<NetworkData>) in
                switch res.result {
                case .success:
                    guard let value = res.result.value else { return }
                    completion(.success(value))
                case .failure(let err):
                    completion(.error(err))
                }
            }
    }
    
    func delete(_ url: String, body: [String:Any]?, header: HTTPHeaders?, completion: @escaping (NetworkResult<NetworkData>) -> Void) {
        Alamofire.request(url, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseObject { (res: DataResponse<NetworkData>) in
                switch res.result {
                case .success:
                    guard let value = res.result.value else { return }
                    completion(.success(value))
                case .failure(let err):
                    completion(.error(err))
                }
            }
    }
}
