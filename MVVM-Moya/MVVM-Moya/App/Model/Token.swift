//
//  User.swift
//  VIPER
//
//  Created by Ha Nguyen Thai on 9/25/19.
//  Copyright © 2019 Ace. All rights reserved.
//

import Foundation

struct Token {
    var token: String
    var expires_at: String
}

extension Token: Decodable {
    
    enum DataKey: String, CodingKey {
        case data
    }
    
    enum TokenCodingKey: String, CodingKey {
        case token = "access_token"
        case expires_at = "expires_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKey.self)
        let detailContainer = try container.nestedContainer(keyedBy: TokenCodingKey.self, forKey: .data)
        token = try detailContainer.decode(String.self, forKey: .token)
        expires_at = try detailContainer.decode(String.self, forKey: .expires_at)
    }
}
