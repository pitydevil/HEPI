//
//  AccountViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class AccountTableViewController: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private let accountTableViewModel = AccountTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        emailLabel.text = namaEmailUser ?? ""
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        versionLabel.text = "\(0.01)"
        
        //MARK: - Check User Sign In Status
        /// Observe sign up status from view model, and segue to main view controller if there are any changes.
        accountTableViewModel.typeErrorObjectObservable.skip(1).subscribe(onNext: { (value) in
            DispatchQueue.main.async { [self] in
                SVProgressHUD.dismiss()
                switch value {
                    case  .success(let typeMessage):
                        popupAlert(title: "Berhasil \(typeMessage) logout!", message: nil, actionTitles: ["Ok"], actionsStyle: [UIAlertAction.Style.default] ,actions:[{ [self] (action1) in
                            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }])
                    default:
                        present(genericAlert(titleAlert: "Terjadi kegagalan dalam logout!", messageAlert: "Silahkan coba beberapa saat lagi!.", buttonText: "Ok"), animated: true)
                }
            }
        }).disposed(by: bags)
    }
}

extension AccountTableViewController  {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            popupAlert(title: "Are you sure want to logout?", message: nil, actionTitles: ["Logout", "Cancel"], actionsStyle: [UIAlertAction.Style.destructive, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                SVProgressHUD.show(withStatus: "Logging Out")
                accountTableViewModel.logoutFunction()
            },nil])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
