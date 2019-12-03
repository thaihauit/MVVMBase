//
//  BaseViewConntroller.swift
//  MVVMBase
//
//  Created by Ha Nguyen Thai on 6/19/19.
//  Copyright © 2019 Ace. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    
}
