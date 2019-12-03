//
//  LoginViewModel.swift
//  Madocon
//
//  Created by Tri Nguyen Minh on 10/31/19.
//  Copyright © 2019 Ha Nguyen Thai. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelProtocol {
    
    let provider = LoginProvider()

    // MARK: - Public properties
    let input: Input
    let output: Output
    
    struct Input {
        let signInnDidTap: AnyObserver<Void>
        let userName:AnyObserver<String>
    }
    
    struct Output {
        let userResult: PublishSubject<User>
    }
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    // Input
    private let signInnDidTapSubject = PublishSubject<Void>()
    private let userInputSuject = PublishSubject<String>()
    
    // Output
    private let userResultSubject = PublishSubject<User>()
    private let errorsSubject = PublishSubject<Error>()
    
    // MARK: - Init and deinit
    init() {
        input = Input(signInnDidTap: signInnDidTapSubject.asObserver(),
                      userName: userInputSuject.asObserver())
        output = Output(userResult: userResultSubject.asObserver())
        signInnDidTapSubject.withLatestFrom(userInputSuject.asObservable()).flatMapLatest { userInput in
            return self.provider.registerUser(name: userInput, token: AppConfig.sharedInstance.tempFcm)
        }.subscribe(onNext: { [weak self] event in
            self?.userResultSubject.onNext(event)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        print("\(self) dealloc")
    }
}
