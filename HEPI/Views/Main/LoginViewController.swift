//
//  LoginViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 10/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class LoginViewController: UIViewController {

    //MARK: - Layout Subviews
    @IBOutlet weak var bgCard: UIView!
    @IBOutlet weak var emailTextfield: LeftPaddedTextfield!
    @IBOutlet weak var passwordTextfield: LeftPaddedTextfield!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var daftarButton: UIButton!
    
    //MARK: Object Declaration
    private let loginViewModel = LoginViewModel()
    private var signUpViewController : SignUpViewController?
    
    override func viewWillLayoutSubviews() {
        //MARK: - Download Tensorflow Lite Model From Firebase Server
        /// Download tflite model from firebase server.
        loginViewModel.checkUser()
        
        //MARK: - Download Tensorflow Lite Model From Firebase Server
        /// Download tflite model from firebase server.
        bgCard.setLoginCard()
        
        //MARK: - Download Tensorflow Lite Model From Firebase Server
        /// Download tflite model from firebase server.
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Register Controller
        signUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpViewController") as SignUpViewController
        
        //MARK: - Download Tensorflow Lite Model From Firebase Server
        /// Download tflite model from firebase server.
        loginViewModel.downloadModel()
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        loginViewModel.isSignedUpObservable.subscribe(onNext: { [self] (value) in
            value ? present(segueToMain(), animated: false) : print("belum signin")
        }).disposed(by: bags)
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        loginViewModel.authErrorCodeObservable.skip(1).subscribe(onNext: { (value) in
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
        loginViewModel.typeErrorObjectObservable.skip(1).subscribe(onNext: { (value) in
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
        
        //MARK: - Response Daftar Button
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        daftarButton.rx.tap.bind { [self] in
            signUpViewController?.modalPresentationStyle = .fullScreen
            signUpViewController?.modalTransitionStyle = .crossDissolve
            present(signUpViewController ?? SignUpViewController(), animated: true)
        }.disposed(by: bags)
        
        //MARK: - Response Login Button
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        /// - Parameters:
        ///     - Email: character subset that's allowed to use on the textfield
        ///     - Password: set of character/string that would like  to be checked.
        loginButton.rx.tap.bind { [self] in
            SVProgressHUD.show(withStatus: "Logging In")
            loginViewModel.loginFirebase(emailTextfield.text ?? "", passwordTextfield.text ?? "")
        }.disposed(by: bags)
    }
}
