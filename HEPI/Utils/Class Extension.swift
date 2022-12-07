//
//  Class Extension.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

//MARK: - Extension UIKit
extension UIView {
    
    //MARK: - Set Base Rounded View
    /// Change UiView Corner Radius to 8
    func setBaseRoundedView() {
        self.layer.cornerRadius = 8
    }
    
    //MARK: - Set Shadow on View
    /// Set UIView Shadow
    func setShadowCard() {
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius  = 2.0
        self.layer.shadowColor   = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset  = CGSize(width: 0.0, height: 2)
        self.layer.backgroundColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).cgColor
        self.layer.masksToBounds = false
    }
}

//MARK: - Extension UIViewController
extension UIViewController {
    
    //MARK: - Hide Keyboard Response Function
    /// Add keyboard dismisser in case there's any changes on the view controller
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Dismiss Keyboard Function
    /// Force any editing to be dismissed
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
