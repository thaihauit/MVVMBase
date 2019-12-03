//
//  CacheMannager.swift
//  MVVMBase
//
//  Created by Ha Nguyen Thai on 6/19/19.
//  Copyright © 2019 Ace. All rights reserved.
//


import Foundation

class CacheManager: NSObject {
    
    private let userDefaults: UserDefaults
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    static let shared = CacheManager()
    private let apiToken = "api_token"
    
    // MARK:- Api token
    func getApiToken() -> String? {
        return userDefaults.string(forKey: apiToken)
    }
    
    func saveApiToken(value: String) {
        userDefaults.set(value, forKey: apiToken)
        userDefaults.synchronize()
    }
    
    func removeApiToken() {
        userDefaults.removeObject(forKey: apiToken)
    }
    
}

