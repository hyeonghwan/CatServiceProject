//
//  Container.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/20.
//

import Foundation

import RxSwift


protocol RxFaovurtieType {
    var favouriteSuccessObservable: Observable<FavouriteResponseWrap> { get }
    var observer1: AnyObserver<FavouriteResponseWrap> { get }
   
}

protocol RxDeleteType{
    var favouriteDeleteObservable: Observable<FavouriteDeleteResponseWrap> { get }
    var observer2: AnyObserver<FavouriteDeleteResponseWrap> { get }
    
    var heartActionDeleteObservable: Observable<FavouriteDeleteResponseWrap> { get }
    var heartObserver: AnyObserver<FavouriteDeleteResponseWrap> { get }
}

typealias RxEventType = RxFaovurtieType & RxDeleteType

class Container: RxEventType {
    var favouriteSuccessObservable: Observable<FavouriteResponseWrap>
    var favouriteDeleteObservable: Observable<FavouriteDeleteResponseWrap>
    var heartActionDeleteObservable: Observable<FavouriteDeleteResponseWrap>
    
    
    var observer1: AnyObserver<FavouriteResponseWrap>
    var observer2: AnyObserver<FavouriteDeleteResponseWrap>
    var heartObserver: AnyObserver<FavouriteDeleteResponseWrap>
    
    var disposeBag = DisposeBag()
    
    
    init() {
        let obSubject1 = PublishSubject<FavouriteResponseWrap>()
        let obSubject2 = PublishSubject<FavouriteDeleteResponseWrap>()
        let obSubject3 = PublishSubject<FavouriteDeleteResponseWrap>()
        
        self.favouriteSuccessObservable = obSubject1
        
        self.favouriteDeleteObservable = obSubject2
        
        self.heartActionDeleteObservable = obSubject3
        
        let subject1 = PublishSubject<FavouriteResponseWrap>()
        let subject2 = PublishSubject<FavouriteDeleteResponseWrap>()
        let subject3 = PublishSubject<FavouriteDeleteResponseWrap>()
        
        observer1 = subject1.asObserver()
        observer2 = subject2.asObserver()
        heartObserver = subject3.asObserver()
        
        subject1
            .subscribe(onNext: obSubject1.onNext(_:))
            .disposed(by: disposeBag)
            
        subject2
            .subscribe(onNext: obSubject2.onNext(_:))
            .disposed(by: disposeBag)
        
        subject3
            .subscribe(onNext: obSubject3.onNext(_:))
            .disposed(by: disposeBag)
        
    }
    
}
