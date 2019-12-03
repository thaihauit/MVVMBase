//
//  BaseRestApi.swift
//  Madocon
//
//  Created by Ha Nguyen Thai on 10/21/19.
//  Copyright © 2019 Ha Nguyen Thai. All rights reserved.
//

import Foundation
import Moya

protocol Restable {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

class BaseRestApi: NSObject {
    class func decodingTask<T: Decodable>(with data: Data, decodingType: T.Type, _ completion: @escaping ResponseCompletion) {
        do {
            let genericModel = try JSONDecoder().decode(decodingType, from: data)
            completion(genericModel)
        } catch {
            completion(nil)
        }
    }
}


