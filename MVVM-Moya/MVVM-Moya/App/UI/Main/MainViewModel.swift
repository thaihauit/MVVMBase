//
//  MainViewModel.swift
//  Madocon
//
//  Created by Ha Nguyen Thai on 10/22/19.
//  Copyright © 2019 Ha Nguyen Thai. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class MainViewModel: ViewModelProtocol {
    
    let provider = LoginProvider()
    private let token = PublishSubject<Token>()

    // MARK: - Public properties
    let input: Input
    let output: Output
    
    struct Input {
        let getTokenInDidTap: AnyObserver<Void>
        let userName:AnyObserver<String>
    }
    
    struct Output {
        let tokenResultObservable: Observable<Token>
        let errorsObservable: Observable<Error>
    }
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // Input
    private let deviceIdSubject = PublishSubject<String>()
    private let tokenDidTapSubject = PublishSubject<Void>()
    private let registerDidTapSubject = PublishSubject<Void>()
    private let userInputSuject = PublishSubject<String>()
    
    // Output
//    private let ResultSubject = PublishSubject<String>()
    private let errorsSubject = PublishSubject<Error>()
    private let tokenResultSubject = PublishSubject<Token>()
    
    // MARK: - Init and deinit
    init() {
        
        input = Input(getTokenInDidTap: tokenDidTapSubject.asObserver(),
                      userName: userInputSuject.asObserver())
        
        output = Output(tokenResultObservable: tokenResultSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
        
        tokenDidTapSubject
            .withLatestFrom(userInputSuject.asObservable())
            .flatMapLatest { userInput in
                return self.provider.createToken(id: userInput)
        }.subscribe(onNext: { [weak self] event in
            CacheManager.shared.saveApiToken(value: event.token)
            self?.tokenResultSubject.onNext(event)
        }).disposed(by: disposeBag)
        
    }
        
    deinit {
        print("\(self) dealloc")
    }
    
}
