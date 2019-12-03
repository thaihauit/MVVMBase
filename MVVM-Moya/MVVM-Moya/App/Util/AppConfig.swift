//
//  AppConfig.swift
//  VIPER
//
//  Created by Ha Nguyen Thai on 9/25/19.
//  Copyright © 2019 Ace. All rights reserved.
//

import Foundation

class AppConfig : NSObject {

static let sharedInstance = AppConfig()
    
    let baseURL = "http://s064.cloud9-solutions.com/api"
    
    //only be used for demo purpose
    let tempFcm = "cLUV-KzV_aM%3AAPA91bHWMjwEN6P9LCUgbxoiDzSdVXqAeC3E6adA4vwV6mmoSXi31nx7ypPa-NFodPFBbk_Ui9NLYIYoXqmoatAuylO7xK1tcPzuwMDJLZr3wwry1FoWgVPJ9ijnphKqpqbZ_kwDwOF_"
    //only be used for demo purpose
    let defaultUserID = "UserIdAsDefault"
}


