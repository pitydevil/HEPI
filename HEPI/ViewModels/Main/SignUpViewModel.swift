//
//  SignUpViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 10/01/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class SignUpViewModel {
    private var authErrorCodeObject: BehaviorRelay<AuthErrorCode.Code> = BehaviorRelay(value: AuthErrorCode.internalError)
    private var typeErrorObject: BehaviorRelay<typeError> = BehaviorRelay(value: typeError.gagalAddData)
    private var isSignedUp: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Object Observation Declaration
    var isSignedUpObservable: Observable<Bool> {
        return isSignedUp.asObservable()
    }
    var authErrorCodeObservable: Observable<AuthErrorCode.Code> {
        return authErrorCodeObject.asObservable()
    }
    var typeErrorObjectObservable: Observable<typeError> {
        return typeErrorObject.asObservable()
    }
    
    //MARK: - Check User Sign in state
    /// return isSignedUp Observer state
    /// from the given components.
    func signUpFirebase(_ emailText : String, _ passwordText: String) {
        if !emailText.isEmpty && !passwordText.isEmpty {
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { [self] user, error in
                if error != nil {
                    if let errCode = AuthErrorCode.Code(rawValue: AuthErrorCode(_nsError: error! as NSError).errorCode) {
                        authErrorCodeObject.accept(errCode)
                    }
                }else {
                    typeErrorObject.accept(.success(typeMessage: "buat akun"))
                    isSignedUp.accept(true)
                }
            }
        }else {
            if emailText.isEmpty && !passwordText.isEmpty {
                typeErrorObject.accept(.emailTidakAda)
            }else if !emailText.isEmpty  && passwordText.isEmpty {
                typeErrorObject.accept(.passwordTidakAda)
            }else {
                typeErrorObject.accept(.emailPassTidakAda)
            }
        }
    }
}
