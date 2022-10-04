//
//  MainViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var backgroundCard : UIView!
    @IBOutlet weak var nameTextfield  : UITextField!
    
    private let starterViewModel = UserViewModel()
    
    override func viewWillLayoutSubviews() {
        backgroundCard.setBaseRoundedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    @IBAction func didTapSegueButton(_ sender : UIButton) {
        
    }
}
