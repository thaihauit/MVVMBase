//
//  LoginViewController.swift
//  Madocon
//
//  Created by Tri Nguyen Minh on 10/31/19.
//  Copyright © 2019 Ha Nguyen Thai. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

class LoginViewController: PrimaryViewController, ControllerType {
    
    typealias ViewModelType = LoginViewModel
    
    // MARK: - Properties
    var viewModel: ViewModelType!
    let disposeBag = DisposeBag()
    var cacheManager: CacheManager!
    
    // MARK: - UI
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        input(with: viewModel)
        output(with: viewModel)
    }

    func input(with viewModel: LoginViewModel) {
        
        // Button action Observable
        signInButton.rx.tap
            .asObservable()
            .subscribe(viewModel.input.signInnDidTap)
            .disposed(by: disposeBag)
        
        // TextField action Observable
        userId.rx.text.orEmpty.asObservable()
            .subscribe(viewModel.input.userName)
            .disposed(by: disposeBag)
        
    }
    
    func output(with viewModel: LoginViewModel) {
        viewModel.output.userResult.subscribe(onNext: { [unowned self] (user) in
            print("Create user Success")
            let alert = UIAlertController(title: "Login notice", message: "Completed!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.presentDialog(alert)
        }).disposed(by: disposeBag)
    }
    
    
}

extension LoginViewController {
    static func create(with viewModel: LoginViewModel) -> UIViewController {
        let controller = ResourceProvider.getViewController(LoginViewController.self)
        controller.viewModel = viewModel
        return controller
    }
}
