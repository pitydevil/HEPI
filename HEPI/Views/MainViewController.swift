//
//  MainViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    
    //MARK: - Layout Subviews
    @IBOutlet weak var backgroundCard : UIView!
    @IBOutlet weak var nameTextfield  : UITextField!
    @IBOutlet weak var signUpButton   : UIButton!
    
    //MARK: Object Declaration
    private let starterViewModel = StarterViewModel()
    
    //MARK: - View Will Layout Subviews
    override func viewWillLayoutSubviews() {
        backgroundCard.setBaseRoundedView()
        starterViewModel.checkUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Download Tensorflow Lite Model From Firebase Server
        /// Download tflite model from firebase server.
        starterViewModel.downloadModel()

        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        starterViewModel.isSignedUpObservable.subscribe(onNext: { [self] (value) in
            value ? present(segueToMain(), animated: false) : print("false")
        }).disposed(by: bags)
        
        //MARK: - Sign Up Button Response Function
        /// Check Sign In state from view model function.
        signUpButton.rx.tap.bind { [self] in
            starterViewModel.setupUserName(nameTextfield.text) { [self] (result) in
                switch result {
                    case .success:
                        starterViewModel.isSignedUp.accept(true)
                    case .tidakAdaText:
                        present(genericAlert(titleAlert: "Nama Tidak Ada!" , messageAlert: "Silahkan isi nama anda terlebih dahulu", buttonText: "Ok"), animated: true)
                    default:
                        print("tidak ada")
                }
            }
        }.disposed(by: bags)
    }
}
