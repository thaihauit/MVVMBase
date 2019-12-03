//
//  ResourceProvider.swift
//  MVVMBase
//
//  Created by Ha Nguyen Thai on 6/19/19.
//  Copyright © 2019 Ace. All rights reserved.
//

import Foundation
import UIKit

class ResourceProvider {
    
    class func getViewController<T: UIViewController>(_ classType: T.Type) -> T {
        return classType.init(nibName:String(describing: classType).components(separatedBy: ".").last!, bundle:nil)
    }
    
}
