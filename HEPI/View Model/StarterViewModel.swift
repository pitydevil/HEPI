//
//  StarterViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class StarterViewModel {
    var isSignedUp: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isSignedUpObservable: Observable<Bool> {
        return isSignedUp.asObservable()
    }
    
    func checkUser() {
        if defaults.string(forKey: nameKeys) != nil {
            isSignedUp.accept(true)
        }else {
            isSignedUp.accept(false)
        }
    }
    
    func setupUserName(_ username : String?, completion: @escaping(_ result: typeError)-> Void) {
        if username == nil {
            completion(.tidakAdaText)
        }else {
            defaults.set(username, forKey: nameKeys)
            completion(.success)
        }
    }
}
