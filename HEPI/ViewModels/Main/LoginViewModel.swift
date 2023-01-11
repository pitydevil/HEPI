//
//  LoginViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 10/01/23.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth
import TensorFlowLiteTaskText

class LoginViewModel {
    
    //MARK: - Object Declaration
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
    
    //MARK: - Download Tensorflow Model
    /// download model using modelLoader function with forebaseModel Library and instantiate TensorflowLiteClassifier based on the downloaded model.
    func downloadModel() {
        ModelLoader.downloadModel(named: "sentiment_analysis") { (customModel, error) in
            guard let customModel = customModel else {
                if let error = error {
                    print(error)
                }
                return
            }
            let options = TFLNLClassifierOptions()
            classifier = TFLNLClassifier.nlClassifier(modelPath: customModel.path, options: options)
        }
    }
    
    //MARK: - Check User Sign in state
    /// return isSignedUp Observer state
    /// from the given components.
    func checkUser() {
        if Auth.auth().currentUser != nil {
            isSignedUp.accept(true)
        }else {
            isSignedUp.accept(false)
        }
    }
    
    //MARK: - Check User Sign in state
    /// return isSignedUp Observer state
    /// from the given components.
    func loginFirebase(_ emailText : String, _ passwordText: String) {
        if !emailText.isEmpty && !passwordText.isEmpty {
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { [self] user, error in
                if error != nil {
                    if let errCode = AuthErrorCode.Code(rawValue: AuthErrorCode(_nsError: error! as NSError).errorCode) {
                        authErrorCodeObject.accept(errCode)
                    }
                }else {
                    typeErrorObject.accept(.success(typeMessage: "Login"))
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
