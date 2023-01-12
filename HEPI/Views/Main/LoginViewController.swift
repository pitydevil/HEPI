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
                    present(genericAlert(titleAlert: "Email Tidak Valid!", messageAlert: "Silahkan masukkan email sesuai dengan format yang benar", buttonText: "Ok"), animated: true)
                    case .internalError:
                    present(genericAlert(titleAlert: "Terjadi Kesalahan pada server!", messageAlert: "Silahkan coba beberapa saat lagi", buttonText: "Ok"), animated: true)
                    case .userDisabled:
                    present(genericAlert(titleAlert: "Akun dinonaktifkan!", messageAlert: "Silahkan email administrator untuk mengaktifkan akun anda", buttonText: "Ok"), animated: true)
                    case .networkError:
                    present(genericAlert(titleAlert: "Gangguan Koneksi Internet!", messageAlert: "Silahkan coba melakukan login kembali", buttonText: "Ok"), animated: true)
                    case .wrongPassword:
                    present(genericAlert(titleAlert: "Password Salah!", messageAlert: "Silahkan coba lagi mengisi password yang benar", buttonText: "Ok"), animated: true)
                    case .userNotFound:
                    present(genericAlert(titleAlert: "Akun tidak ada!", messageAlert: "Akun yang anda masukkan tidak terdapat pada database ami", buttonText: "Ok"), animated: true)
                    case .unverifiedEmail:
                    present(genericAlert(titleAlert: "Email Belum Diverifdikasi", messageAlert: "Silahkan verifikasi email anda terlebih dahulu", buttonText: "Ok"), animated: true)
                    default:
                    present(genericAlert(titleAlert: "Terjadi kesalahan pada server!", messageAlert: "Silahkan coba beberapa saat lagi.", buttonText: "Ok"), animated: true)
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
                        present(genericAlert(titleAlert: "Email dan Password Kosong!", messageAlert: "Silahkan isi email dan password terlebih dahulu", buttonText: "Ok"), animated: true)
                    case .passwordTidakAda:
                        present(genericAlert(titleAlert: "Password Kosong!", messageAlert: "Silahkan isi password terlebih dahulu", buttonText: "Ok"), animated: true)
                    case .emailTidakAda:
                        present(genericAlert(titleAlert: "Email Kosong!", messageAlert: "Silahkan isi email terlebih dahulu", buttonText: "Ok"), animated: true)
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
