//
//  LoginApi.swift
//  VIPER
//
//  Created by Ha Nguyen Thai on 9/25/19.
//  Copyright © 2019 Ace. All rights reserved.
//

import Foundation
import Moya

enum LoginUri: String {
    case createToken = "createToken"
    case registerUser = "registerUser"
    var path: String {
        switch self {
        case .createToken:
            return "login"
        case .registerUser:
            return "save-user"
        }
    }
}

enum LoginApi {
    case createToken(id: String)
    case registerUser(name: String, token: String)
    
}

extension LoginApi: TargetType {
    var headers: [String : String]? {
        switch self {
        case .createToken(_):
            return [
                    "Content-Type": "application/json",
                    "application/json":"Accept"]
        case .registerUser(_):
            return ["Authorization": "Bearer \(String(describing: CacheManager.init().getApiToken()!))"]
        }
    }
    
    var baseURL: URL {
        return URL(string: AppConfig.sharedInstance.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createToken(_):
            return LoginUri.createToken.path
        case .registerUser(_):
            return LoginUri.registerUser.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createToken(_):
            return .post
        case .registerUser(_):
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .createToken(let id):
            let params: [String: Any] = ["user_id": id]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .registerUser(let name, let token):
            return .requestParameters(parameters: ["user_name": name, "fcm_token": token], encoding: URLEncoding.default)
        }
    }
}


