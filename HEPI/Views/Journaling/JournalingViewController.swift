//
//  JournalingViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit
import RxCocoa
import RxSwift

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
        journalViewModel.getAllJournal()
    }
    
    //MARK: - View Will Layout Subviews
    override func viewWillLayoutSubviews() {
        tableView.separatorStyle = .none
        tableView.delegate = self
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
        navigationController?.navigationBar.topItem?.title = "Welcome, \(journalViewModel.getUsername())!"
        
        //MARK: - Observe Journal Array
        /// Observe journal view model's journal array in case there's any changes, and will update array of journal if there are any changes
        journalViewModel.journalModelArrayObserver.subscribe(onNext: { [self] (value) in
            journalList.accept(value)
            DispatchQueue.main.async { [self] in
                resultLabel.text = "Showing \(value.count) Results for: \(changeDateIntoDDMM(checkFinalObject.value.checkInDate)) - \(changeDateIntoDDMM(checkFinalObject.value.checkOutDate))"
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)

        //MARK: - Bind Journal List with Table View
        /// Bind journal list with journalingTableView
        journalList.bind(to: tableView.rx.items(cellIdentifier: "journalingCell", cellType: JournalingTableViewCell.self)) { row, model, cell in
            cell.configureCell(journal: model)
        }.disposed(by: bags)
        
        //MARK: - Journal Button Response Function
        /// Segue to Detail Journal View Controller.
        addButton.rx.tap.bind { [self] in
            detailController?.journalObject = nil
            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }.disposed(by: bags)
        
        //MARK: - Journal Button Response Function
        /// Segue to Detail Journal View Controller.
        dateSearchCard.searchButton.rx.tap.bind { [self] in
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
        self.present(vc, animated: true)
    }
}

extension JournalingViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let delete = UIContextualAction(style: .destructive, title: "Hapus") { [self] (action, sourceView, completionHandler) in
            //MARK: - Delete Journal Provider Function
            /// Returns summaryGenerate Enumeration
            /// - Parameters:
            ///     - dateCreated: date object that's gonna be passed to the provider, so the provider can query the journal based on the given date.
            popupAlert(title: "Apakah anda ingin menghapus jurnal ini?", message: nil, actionTitles: ["Hapus", "Batal"], actionsStyle: [UIAlertAction.Style.destructive, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                detailJournalViewModel.deleteJournal(journalList.value[indexPath.row].dateCreated!) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success:
                            popupAlert(title: "Sukses", message: "Berhasil Menghapus Jurnal!", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.default], actions: [nil])
                        case .gagalAddData:
                            present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Menghapus Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                        default:
                            print("gagal")
                        }
                    }
                }
            },nil])
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailController?.journalObject = BehaviorRelay(value: Journal())
        detailController?.journalObject!.accept(journalList.value[indexPath.row])
        detailController?.journalObjectObservable.subscribe(onNext: {  _ in
            tableView.reloadData()
        }).disposed(by: bags)
        navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
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
