//
//  StarterViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import TensorFlowLiteTaskText

class StarterViewModel {
    
    //MARK: - Object Declaration
    var isSignedUp: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Object Observation Declaration
    var isSignedUpObservable: Observable<Bool> {
        return isSignedUp.asObservable()
    }
    
    //MARK: - Observe Journal Array
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
        if defaults.string(forKey: nameKeys) != nil {
            isSignedUp.accept(true)
        }else {
            isSignedUp.accept(false)
        }
    }
    
    //MARK: - Setup Username Function
    /// Returns typeError enumeration
    /// from the given components.
    /// - Parameters:
    ///     - username: character subset that's gonna be saved on to user defaults,
    func setupUserName(_ username : String?, completion: @escaping(_ result: typeError)-> Void) {
        if username == nil {
            completion(.tidakAdaText)
        }else {
            defaults.set(username, forKey: nameKeys)
            completion(.success)
        }
    }
}
