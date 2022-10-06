//
//  HelperClass.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

public func segueToMain() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController =  storyboard.instantiateViewController(withIdentifier: "mainTabbar")
    viewController.modalPresentationStyle = .fullScreen
    return viewController
}


public func genericAlert(titleAlert : String, messageAlert : String, buttonText : String) -> UIAlertController {
    let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
    let cancel = UIAlertAction(title: buttonText, style: .cancel)
    alert.addAction(cancel)
    return alert
}

public func changeDateIntoStringDate(Date : Date) -> String {
    let dateF = DateFormatter()
    dateF.dateFormat = "dd MMM yyyy"
    return dateF.string(from: Date)
}

