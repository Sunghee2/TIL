//
//  EpisodeService.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Alamofire

struct EpisodeService: APIManager, Requestable {
    
    typealias NetworkData = ResponseObject<Episode>
    static let shared = EpisodeService()
    let EpisodeURL = url("/webtoons/episodes/list")
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json"
    ]
    
    // get episode list API
    func getEpisodeList(wtIdx: Int, completion: @escaping (ResponseObject<Episode>) -> Void) {
        
        let queryURL = EpisodeURL + "/\(wtIdx)"
        
        gettable(queryURL, body: nil, header: headers) { res in
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

