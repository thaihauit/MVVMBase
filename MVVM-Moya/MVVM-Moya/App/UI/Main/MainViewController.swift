//
//  MainViewController.swift
//  Madocon
//
//  Created by Ha Nguyen Thai on 10/22/19.
//  Copyright © 2019 Ha Nguyen Thai. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

class MainViewController: PrimaryViewController, ControllerType {
    
    typealias ViewModelType = MainViewModel
    
    // MARK: - Properties
    var viewModel: ViewModelType!
    let disposeBag = DisposeBag()
    var cacheManager: CacheManager!
    
    // MARK: - UI
    @IBOutlet weak var getTokenButton: UIButton!
    @IBOutlet weak var nameTextView: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        input(with: viewModel)
        output(with: viewModel)
    }
    
    // MARK:- DI
    func setCacheManager(cacheManager: CacheManager) {
        self.cacheManager = cacheManager
    }
    
    func input(with viewModel: MainViewModel) {
        
        // Button action Observable
        getTokenButton.rx.tap
            .asObservable()
            .subscribe(viewModel.input.getTokenInDidTap)
            .disposed(by: disposeBag)
        
        // TextField action Observable
        nameTextView.rx.text.orEmpty
            .asObservable()
            .subscribe(viewModel.input.userName)
            .disposed(by: disposeBag)
    }
    
    func output(with viewModel: MainViewModel) {
        // Output
        viewModel.output.errorsObservable
            .subscribe(onNext: {(error) in
                
            }).disposed(by: disposeBag)
        
        viewModel.output
            .tokenResultObservable
            .subscribe(onNext: { [unowned self] (token) in
                self.navigateToScreen(LoginViewController.create(with: LoginViewModel()))
            })
            .disposed(by: disposeBag)
    }

}

extension MainViewController {
    static func create(with viewModel: MainViewModel) -> UIViewController {
        let controller = ResourceProvider.getViewController(MainViewController.self)
        controller.viewModel = viewModel
        controller.setCacheManager(cacheManager: CacheManager.init(userDefaults: .standard))
        return controller
    }
}
