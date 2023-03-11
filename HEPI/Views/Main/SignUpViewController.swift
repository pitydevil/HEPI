//
//  SignUpViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 10/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class SignUpViewController: UIViewController {

    //MARK: - Layout Subviews
    @IBOutlet weak var emailTextfield: LeftPaddedTextfield!
    @IBOutlet weak var passwordTextfield: LeftPaddedTextfield!
    @IBOutlet weak var bgCard: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var daftarButton: UIButton!
    
    //MARK: Object Declaration
    private let signUpViewModel = SignUpViewModel()
    
    override func viewWillLayoutSubviews() {
        //MARK: - Download Tensorflow Lite Model From Firebase Server
        /// Download tflite model from firebase server.
        bgCard.setLoginCard()
        
        //MARK: - Download Tensorflow Lite Model From Firebase Server
        /// Download tflite model from firebase server.
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        signUpViewModel.isSignedUpObservable.subscribe(onNext: { [self] (value) in
            value ? present(segueToMain(), animated: false) : print("belum signin")
        }).disposed(by: bags)
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        signUpViewModel.authErrorCodeObservable.skip(1).subscribe(onNext: { (value) in
            DispatchQueue.main.async { [self] in
                SVProgressHUD.dismiss()
                switch value {
                case .invalidEmail:
                present(genericAlert(titleAlert: "Email is not valid!", messageAlert: "Recheck your email.", buttonText: "Okay"), animated: true)
                case .networkError:
                present(genericAlert(titleAlert: "Network Error!", messageAlert: "Recheck your internet connection", buttonText: "Okay"), animated: true)
                case .wrongPassword:
                present(genericAlert(titleAlert: "Invalid Password!", messageAlert: "Your password is incorrect.", buttonText: "Okay"), animated: true)
                case .userNotFound:
                present(genericAlert(titleAlert: "Account is not found!", messageAlert: "Your email is not found in our database", buttonText: "Okay"), animated: true)
              
                default:
                present(genericAlert(titleAlert: "Network Error!", messageAlert: "Recheck your internet connection", buttonText: "Okay"), animated: true)
                }
            }
        }).disposed(by: bags)
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        signUpViewModel.typeErrorObjectObservable.skip(1).subscribe(onNext: { (value) in
            DispatchQueue.main.async { [self] in
                SVProgressHUD.dismiss()
                switch value {
                case .emailPassTidakAda:
                    present(genericAlert(titleAlert: "Email and password is empty!", messageAlert: "Please fill your email and password first.", buttonText: "Okay"), animated: true)
                case .passwordTidakAda:
                    present(genericAlert(titleAlert: "Password is empty!", messageAlert: "Fill your password first.", buttonText: "Okay"), animated: true)
                case .emailTidakAda:
                    present(genericAlert(titleAlert: "Email is Empty!", messageAlert: "Fill your email first.", buttonText: "Okay"), animated: true)
                default:
                    print("testt")
                }
            }
        }).disposed(by: bags)
        
        //MARK: - Response Login Button
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        /// - Parameters:
        ///     - Email: character subset that's allowed to use on the textfield
        ///     - Password: set of character/string that would like  to be checked.
        backButton.rx.tap.bind { [self] in
            dismiss(animated: true)
        }.disposed(by: bags)
        
        
        //MARK: - Response Login Button
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        /// - Parameters:
        ///     - Email: character subset that's allowed to use on the textfield
        ///     - Password: set of character/string that would like  to be checked.
        daftarButton.rx.tap.bind { [self] in
            SVProgressHUD.show(withStatus: "Signing Up")
            signUpViewModel.signUpFirebase(emailTextfield.text ?? "", passwordTextfield.text ?? "")
        }.disposed(by: bags)
    }
}
