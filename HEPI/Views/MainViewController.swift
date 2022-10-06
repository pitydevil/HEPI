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
    
    @IBOutlet weak var backgroundCard : UIView!
    @IBOutlet weak var nameTextfield  : UITextField!
    @IBOutlet weak var signUpButton   : UIButton!
    
    private let starterViewModel = StarterViewModel()
    
    override func viewWillLayoutSubviews() {
        backgroundCard.setBaseRoundedView()
        starterViewModel.checkUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starterViewModel.isSignedUpObservable.subscribe(onNext: { (value) in
            if value {
                self.present(segueToMain(), animated: false)
            }
        }).disposed(by: bags)
        
        signUpButton.rx.tap.bind {
            let valueX =  self.starterViewModel.isSignedUp
            self.starterViewModel.setupUserName(self.nameTextfield.text) { result in
                switch result {
                    case .success:
                        valueX.accept(true)
                    case .tidakAdaText:
                        self.present(genericAlert(titleAlert: "Nama Tidak Ada!" , messageAlert: "Silahkan isi nama anda terlebih dahulu", buttonText: "Ok"), animated: true)
                    default:
                        print("tidak ada")
                }
            }
        }.disposed(by: bags)
    }
}
