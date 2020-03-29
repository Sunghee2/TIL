//
//  EpisodeDetailService.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 10/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Alamofire

struct EpisodeDetailService: APIManager, Requestable {
    
    typealias NetworkData = ResponseObject<EpisodeDetail>
    static let shared = EpisodeDetailService()
    let EpisodeURL = url("/webtoons/episodes")
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json"
    ]
    
    // get episode Detail API
    func getEpisodeDetail(epIdx: Int, completion: @escaping (ResponseObject<EpisodeDetail>) -> Void) {
        
        let queryURL = EpisodeURL + "/\(epIdx)"
        
        gettable(queryURL, body: nil, header: headers) { res in
            switch res {
            case .success(let value):
                
                print("######### success #########")
                print(value)
                print("######### success #########")

            case .error(let error):
                
                print("######### error #########")
                print(error)
                print("######### error #########")
            }
        }
    }
}
