//
//  CommentService.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by Sunghee Lee on 25/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import Alamofire

//struct CommentService: APIManager, Requestable {
//    
//    typealias NetworkData = ResponseObject<Comment>
//    static let shared = CommentService()
//    let commentURL = url("/webtoons/episodes")
//    let headers: HTTPHeaders = [
//        "Content-Type" : "application/json"
//    ]
//    
//    // get episode Detail API
//    func getComment(epIdx: Int, completion: @escaping (ResponseObject<Comment>) -> Void) {
//        
//        let queryURL = commentURL + "/\(epIdx)"
//        
//        gettable(queryURL, body: nil, header: headers) { res in
//            switch res {
//            case .success(let value):
//                
//                print("######### success #########")
//                print(value)
//                print("######### success #########")
//                
//            case .error(let error):
//                
//                print("######### error #########")
//                print(error)
//                print("######### error #########")
//            }
//        }
//    }
//}
