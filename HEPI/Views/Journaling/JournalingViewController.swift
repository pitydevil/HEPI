//
//  JournalingViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

@available(iOS 16.0, *)
class JournalingViewController: UIViewController {

    //MARK: - Layout Subviews
    @IBOutlet weak var dateSearchCard: dateSearchCard!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var addButton: UIBarButtonItem!
    
    //MARK: Object Declaration
    private let detailJournalViewModel = DetailJournalViewModel()
    private let journalViewModel = JournalViewModel()
    private let journalList = BehaviorRelay<[Journal]>(value: [])
    private var detailController : DetailJournalViewController?
    private var checkFinalObject = BehaviorRelay<CheckIn>(value:CheckIn(checkInDate: Date(), checkOutDate: Date()))
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: "Fetching Journal")
        journalViewModel.getAllJournal()
    }
    
    //MARK: - View Will Layout Subviews
    override func viewWillLayoutSubviews() {
        tableView.separatorStyle = .none
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Set Touch Responder to Textfield
        dateSearchCard.dateTextfield.addTarget(self, action: #selector(responseTanggal), for: .allTouchEvents)
        
        //MARK: - Delegate Registration
        dateSearchCard.dateTextfield.delegate = self
        
        //MARK: - Register Controller
        detailController = UIStoryboard(name: "Journal", bundle: nil).instantiateViewController(identifier: "detailViewController") as DetailJournalViewController
        
        //MARK: - Register TableView
        tableView.register(UINib(nibName: "JournalingTableViewCell", bundle: nil), forCellReuseIdentifier: "journalingCell")
 
        //MARK: - Get Misc Information from ViewModel
        navigationController?.navigationBar.topItem?.title = "Hi There!"
        
        //MARK: - Observe Journal Array
        /// Observe journal view model's journal array in case there's any changes, and will update array of journal if there are any changes
        journalViewModel.journalModelArrayObserver.subscribe(onNext: { [self] (value) in
            journalList.accept(value)
            DispatchQueue.main.async { [self] in
                SVProgressHUD.dismiss()
                resultLabel.text = "Showing \(value.count) Results for: \(changeDateIntoDDMM(checkFinalObject.value.checkInDate)) - \(changeDateIntoDDMM(checkFinalObject.value.checkOutDate))"
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Error Firebase Model
        /// Observe journal view model's journal array in case there's any changes, and will update array of journal if there are any changes
        journalViewModel.journalObjectErrorObserver.skip(1).subscribe(onNext: { (value) in
            DispatchQueue.main.async { [self] in
                present(genericAlert(titleAlert: "Terjadi kesalahan saat mengambil data buku harian!", messageAlert: "\(value)", buttonText: "Ok"), animated: true)
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)

        //MARK: - Bind Journal List with Table View
        /// Bind journal list with journalingTableView
        journalList.bind(to: tableView.rx.items(cellIdentifier: "journalingCell", cellType: JournalingTableViewCell.self)) { row, model, cell in
            cell.configureCell(journal: model)
        }.disposed(by: bags)
        
        //MARK: - RESPONSE TABLE VIEW DIDSELECT DELEGATE FUNCTION
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        tableView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
            tableView.deselectRow(at: indexPath, animated: true)
            detailController?.journalObject = BehaviorRelay(value: Journal())
            detailController?.journalObject!.accept(journalList.value[indexPath.row])
            detailController?.journalObjectObservable.subscribe(onNext: { [self]  _ in
                tableView.reloadData()
            }).disposed(by: bags)
            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Journal Button Response Function
        /// Segue to Detail Journal View Controller.
        addButton.rx.tap.bind { [self] in
            detailController?.journalObject = nil
            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }.disposed(by: bags)
        
        //MARK: - Journal Button Response Function
        /// Segue to Detail Journal View Controller.
        dateSearchCard.searchButton.rx.tap.bind { [self] in
            SVProgressHUD.show(withStatus: "Fetching Journal")
            journalViewModel.getSummaryMood(checkFinalObject.value.checkInDate, checkFinalObject.value.checkOutDate)
        }.disposed(by: bags)
    }
    
    //MARK: - Bind Did Select Row with Rx Item Selected
    /// TableView Did Select delegate function and response accordingnly.
    @objc private func responseTanggal(_ gesture: UITapGestureRecognizer) {
        let vc = ModalCheckInOutViewController()
        vc.modalPresentationStyle = .pageSheet
        //MARK: - Bind Journal List with Table View
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        vc.checkFinalObjectObserver.skip(1).subscribe(onNext: { [self] (value) in
            checkFinalObject.accept(value)
            DispatchQueue.main.async { [self] in
                dateSearchCard.dateTextfield.text = "\(changeDateIntoDDMM(checkFinalObject.value.checkInDate)) - \(changeDateIntoDDMM(checkFinalObject.value.checkOutDate))"
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        present(vc, animated: true)
    }
}

//MARK: - UITextfield Delegate
extension JournalingViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateSearchCard.dateTextfield {
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
