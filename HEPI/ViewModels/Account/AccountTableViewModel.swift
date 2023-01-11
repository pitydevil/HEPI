//
//  AccountTableViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class AccountTableViewModel {
   
    //MARK: - Object Declaration
    private var typeErrorObject: BehaviorRelay<typeError> = BehaviorRelay(value: typeError.gagalAddData)
   
    //MARK: - Object Observation Declaration
    var typeErrorObjectObservable: Observable<typeError> {
        return typeErrorObject.asObservable()
    }

    //MARK: - Check User Sign In Status
    /// Observe sign up status from view model, and segue to main view controller if there are any changes.
    func logoutFunction() {
         try? Auth.auth().signOut()
         typeErrorObject.accept(.success(typeMessage: "melakukan"))
    }
}
