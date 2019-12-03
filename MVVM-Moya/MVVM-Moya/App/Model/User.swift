//
//  User.swift
//  Madocon
//
//  Created by Tri Nguyen Minh on 10/31/19.
//  Copyright © 2019 Ha Nguyen Thai. All rights reserved.
//

import Foundation
struct User {
    var user_id: String
    var user_name: String
}

extension User: Decodable {

    enum DataKey: String, CodingKey {
        case data
    }

    enum UserCodingKey: String, CodingKey {
        case user_id = "user_id"
        case user_name = "user_name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKey.self)
        let detailContainer = try container.nestedContainer(keyedBy: UserCodingKey.self, forKey: .data)
        user_id = try detailContainer.decode(String.self, forKey: .user_id)
        user_name = try detailContainer.decode(String.self, forKey: .user_name)
    }
}
