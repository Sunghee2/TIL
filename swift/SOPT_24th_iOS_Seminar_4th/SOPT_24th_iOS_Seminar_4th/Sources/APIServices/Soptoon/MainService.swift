//
//  MainService.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Alamofire

struct MainService: APIManager, Requestable {
    
    typealias NetworkData = ResponseArray<Soptoon>
    static let shared = MainService()
    let MainURL = url("/webtoons/main")
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json"
    ]
    
    // get soptoon list API
    func getSoptoon(flag: Int, completion: @escaping ([Soptoon]) -> Void) {
        
        let queryURL = MainURL + "/\(flag)"
        
        gettable(queryURL, body: nil, header: headers) { res in
            switch res {
            case .success(let value):
                
                print("######### success #########")
                print(value)
                print("######### success #########")
                
                guard let soptoonList = value.data else { return }
                
                completion(soptoonList)
            case .error(let error):
                
                print("######### error #########")
                print(error)
                print("######### error #########")
            }
        }
    }
}

