//
//  WebtoonService.swift
//  NetworkSeminar
//
//  Created by wookeon on 05/06/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Foundation
import Alamofire

struct WebtoonService {
    
    static let shared = WebtoonService()
    
    func getWebtoon(flag: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.WebtoonMainURL + "/\(flag)"
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResponseArray<Webtoon>.self, from: value)
                                    
                                    switch result.success {
                                    case true:
                                        completion(.success(result.data!))
                                    case false:
                                        completion(.requestErr(result.message))
                                    }
                                } catch {
                                    completion(.pathErr)
                                }
                            case 400:
                                completion(.pathErr)
                            case 500:
                                completion(.serverErr)
                                
                            default:
                                break
                            }
                        }
                    }
                    break
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(.networkFail)
                    break
                }
        }
    }
}
