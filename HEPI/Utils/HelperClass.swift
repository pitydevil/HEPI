//
//  HelperClass.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

//MARK: - Observe Journal Array
/// Returns boolean true or false
/// from the given components.
public func segueToMain() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController =  storyboard.instantiateViewController(withIdentifier: "mainTabbar")
    viewController.modalPresentationStyle = .fullScreen
    return viewController
}

//MARK: - Observe Journal Array
/// Returns boolean true or false
/// from the given components.
/// - Parameters:
///     - allowedCharacter: character subset that's allowed to use on the textfield
///     - text: set of character/string that would like  to be checked.
public func genericAlert(titleAlert : String, messageAlert : String, buttonText : String) -> UIAlertController {
    let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
    let cancel = UIAlertAction(title: buttonText, style: .cancel)
    alert.addAction(cancel)
    return alert
}

//MARK: - Observe Journal Array
/// Returns boolean true or false
/// from the given components.
/// - Parameters:
///     - allowedCharacter: character subset that's allowed to use on the textfield
///     - text: set of character/string that would like  to be checked.
public func changeDateIntoStringDate(Date : Date) -> String {
    let dateF = DateFormatter()
    dateF.dateFormat = "dd MMM yyyy"
    return dateF.string(from: Date)
}

//MARK: - Observe Journal Array
/// Returns boolean true or false
/// from the given components.
public func errorAlert() -> UIAlertController {
    let alert = UIAlertController(title: "Reactive Unexpected Error", message: "Please try again later", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Ok", style: .cancel)
    alert.addAction(cancel)
    return alert
}


