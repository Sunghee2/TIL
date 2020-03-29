//
//  ResponseArray.swift
//  NetworkSeminar
//
//  Created by wookeon on 05/06/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

struct ResponseArray<T: Codable>: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [T]?
}
