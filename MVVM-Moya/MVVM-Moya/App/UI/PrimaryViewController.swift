//
//  PrimaryViewController.swift
//  nyk
//
//  Created by Elaine Chong on 6/22/15.
//  Copyright (c) 2015 BuzzElement. All rights reserved.
//

import UIKit

class PrimaryViewController: BaseViewController {

    // MARK:- UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationController?.navigationBar.barStyle            = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Const.colorWhite]
        self.navigationController?.navigationBar.tintColor           = Const.colorWhite
        self.navigationController?.navigationBar.barTintColor        = Const.colorBlue400
        self.navigationController?.navigationBar.isOpaque = true
    }

    // MARK:- Setup UI

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}
