//
//  ThreadManager.swift
//  B+Com U
//
//  Created by Ha Nguyen Thai on 5/21/19.
//  Copyright © 2019 Cloud 9. All rights reserved.
//

import Foundation

class ThreadManager: NSObject {
    
    static func asyncGlobalQueueWith(_ qos: DispatchQoS, _ block: @escaping () ->Void) {
        DispatchQueue.global(qos: qos.qosClass).async(execute: block)
    }
    
    static func mainQueue(_ block: @escaping () ->Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    static func mainQueueAfter(_ time: DispatchTime, _ block: @escaping () ->Void) {
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
}
