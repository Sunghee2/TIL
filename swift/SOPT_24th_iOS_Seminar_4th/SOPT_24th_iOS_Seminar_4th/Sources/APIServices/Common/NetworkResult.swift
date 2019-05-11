//
//  NetworkResult.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

enum NetworkResult<T> {
    case success(T)
    case error(Error)
}
