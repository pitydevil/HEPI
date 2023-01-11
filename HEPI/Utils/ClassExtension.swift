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
    
    //MARK: - Set Shadow on Login View
    /// Set UIView Shadow
    func setLoginCard() {
        self.layer.cornerRadius = 8
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
    
    //MARK: - Custom Alert Function
    /// Returns UIAlert Controller with given parameter
    /// - Parameters:
    ///     - titlAlert: title alert text for the UIAlertController Title
    ///     - messageAlert: message alert text for the UIAlertController messageText
    ///     - buttonText:  button text for the UIAlertController button text
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actionsStyle : [UIAlertAction.Style], actions:[((UIAlertAction) -> Void)?]) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           for (index, title) in actionTitles.enumerated() {
               let action = UIAlertAction(title: title, style: actionsStyle[index], handler: actions[index])
               alert.addAction(action)
           }
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITextField{
    
    func setLeftPaddingPoints(_ amount:CGFloat){
       let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
       self.leftView = paddingView
       self.leftViewMode = .always
   }
    
    func setLeftImage(_ imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageName)
        self.leftView = imageView;
        self.leftViewMode = .always
    }
}
