//
//  SecondaryViewController.swift
//  nyk
//
//  Created by Elaine Chong on 6/22/15.
//  Copyright (c) 2015 BuzzElement. All rights reserved.
//

import Alamofire
import UIKit

class SecondaryViewController: BaseViewController {
    
    // MARK:- UIViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        if responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.navigationController?.navigationBar.barStyle            = .default
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Const.colorRed]
        self.navigationController?.navigationBar.tintColor           = Const.colorRed
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Const.colorRed,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)]
        self.navigationController?.navigationBar.barTintColor        = Const.colorWhite
        self.navigationController?.navigationBar.backgroundColor     = Const.colorWhite
        self.navigationController?.navigationBar.shadowImage         = UIImage()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavigationBarClose"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onClickClose))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- onClickClose
    
    @objc func onClickClose() {
        self.close()
    }


}
