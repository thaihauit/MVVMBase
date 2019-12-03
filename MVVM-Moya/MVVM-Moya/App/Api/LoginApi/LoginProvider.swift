//
//  LoginMagager.swift
//  VIPER
//
//  Created by Ha Nguyen Thai on 9/30/19.
//  Copyright © 2019 Ace. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol Loginable {
    func createToken(id : String) -> Observable<Token>
    func registerUser(name: String, token: String) -> Observable<User>
}

struct LoginProvider: Loginable, Restable {
    
    var provider = MoyaProvider<LoginApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func createToken(id : String) -> Observable<Token> {
        return provider.rx.request(LoginApi.createToken(id: id)).debug().map(Token.self).asObservable()
    }
    
    func registerUser(name: String, token: String) -> Observable<User> {
        return provider.rx.request(LoginApi.registerUser(name: name, token: token)).debug().map(User.self).asObservable()
    }

}

