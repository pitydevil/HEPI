//
//  DetailJournalViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit
import RxSwift
import RxCocoa

@available(iOS 16.0, *)
class DetailJournalViewController: UIViewController {

    //MARK: - Layout Subviews
    @IBOutlet var writeButtonPressed: UIBarButtonItem!
    @IBOutlet var deleteButtonPressed: UIBarButtonItem!
    @IBOutlet var journalTitleTextfield: UITextField!
    @IBOutlet var dateTextfield: UITextField!
    @IBOutlet var descriptionTextview: UITextView!

    //MARK: Object Declaration
    private let detailJournalViewModel = DetailJournalViewModel()
    var journalObject : BehaviorRelay<Journal>?
    
    //MARK: Object Observer Declaration
    var journalObjectObservable: Observable<Journal> {
        return journalObject?.asObservable() ?? BehaviorRelay(value: Journal()).asObservable()
    }
   
    //MARK: - View Will Layout Subviews
    override func viewWillLayoutSubviews() {
        journalTitleTextfield.setLeftPaddingPoints(8)
        journalTitleTextfield.setBaseRoundedView()
        descriptionTextview.setBaseRoundedView()
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        //MARK: Check Journal Object State
        if journalObject != nil {
            deleteButtonPressed.isHidden = false
            title = "Edit Journal"
            //MARK: - Observe Journal Object Value
            /// Change UI Object based on journal value
            journalObjectObservable.subscribe(onNext: { [self] (value) in
                dateTextfield.text         = changeDateIntoStringDate(Date: value.dateCreated!)
                journalTitleTextfield.text = value.titleJournal
                descriptionTextview.text   = value.descJournal
            }).disposed(by: bags)
        }else {
            title = "Create Journal"
            dateTextfield.text           = changeDateIntoStringDate(Date: Date())
            journalTitleTextfield.text   = nil
            descriptionTextview.text     = nil
            deleteButtonPressed.isHidden = true
        }
    }
    
    //MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //MARK: - Responder to Dismiss any Keyboard Event
        hideKeyboardWhenTappedAround()
        
        //MARK: - Delete Button Response Function
        deleteButtonPressed.rx.tap.bind { [self] in
            
            //MARK: - Delete Journal Provider Function
            /// Returns summaryGenerate Enumeration
            /// - Parameters:
            ///     - dateCreated: date object that's gonna be passed to the provider, so the provider can query the journal based on the given date.
            popupAlert(title: "Apakah anda ingin menghapus jurnal ini?", message: nil, actionTitles: ["Hapus", "Batal"], actionsStyle: [UIAlertAction.Style.destructive, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                detailJournalViewModel.deleteJournal(journalObject!.value.dateCreated!) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success:
                            popupAlert(title: "Sukses", message: "Berhasil Menghapus Jurnal!", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.default], actions: [{ [self] (action1) in
                                navigationController?.popViewController(animated: true)
                            }])
                        case .gagalAddData:
                            present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Menghapus Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                        default:
                            print("gagal")
                        }
                    }
                }
            },nil])
        }.disposed(by: bags)
  
        //MARK: - Write Button Response Function
        writeButtonPressed.rx.tap.bind { [self] in
            //MARK: - Check Journal Object State
            if journalObject == nil {
                //MARK: - Detail Journal View Model Add Function
                /// Returns boolean true or false
                /// from the given components.
                /// - Parameters:
                ///     - titleJournal: journal title for the journal title
                ///     - descJournal: journal description for the journal object
                ///     - moodDesc: journal mood description for the journal object
                ///     - moodImage: journal mood image for the journal object
                popupAlert(title: "Apakah anda ingin menyimpan buku harian ini?", message: nil, actionTitles: ["Simpan", "Batal"], actionsStyle: [UIAlertAction.Style.default, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                    detailJournalViewModel.addJournal(journalTitleTextfield.text ?? "", descriptionTextview.text) { (result) in
                        DispatchQueue.main.async { [self] in
                            switch result {
                                case .success:
                                popupAlert(title: "Sukses", message: "Berhasil Menambah Jurnal!", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.default], actions: [{ [self] (action1) in
                                    navigationController?.popViewController(animated: true)
                                }])
                                case .gagalAddData:
                                    present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Penyimpanan Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                                case .inputTidakLengkap:
                                    present(genericAlert(titleAlert: "Invalid Input!", messageAlert: "Input Tidak Lengkap, silahkan melengkapi input terlebih dahulu!", buttonText: "Ok"), animated: true)
                                default:
                                    present(genericAlert(titleAlert: "Error!", messageAlert: "Terjadi Kesalahan Dalam Melakukan Penyimpanan Data, Silahkan Coba Lagi", buttonText: "Ok"), animated: true)
                                }
                            }
                        }
                },nil])
            }else {
                //MARK: - Detail Journal View Model Update Function
                /// Returns  typeError Enumeration
                /// from the given components.
                /// - Parameters:
                ///     - titleJournal: journal title for the journal title
                ///     - descJournal: journal description for the journal object
                ///     - moodDesc: journal mood description for the journal object
                ///     - moodImage: journal mood image for the journal object
                popupAlert(title: "Apakah anda ingin menyunting buku harian ini?", message: nil, actionTitles: ["Simpan", "Batal"], actionsStyle: [UIAlertAction.Style.default, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                    detailJournalViewModel.updateJournal(journalTitleTextfield.text ?? "", descriptionTextview.text, journalObject!.value.dateCreated!) { result in
                        DispatchQueue.main.async { [self] in
                            switch result {
                                case .success:
                                popupAlert(title: "Sukses", message: "Berhasil Menyunting Jurnal!", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.default], actions: [{ [self] (action1) in
                                    navigationController?.popViewController(animated: true)
                                }])
                                case .gagalAddData:
                                    present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Pembaharuan Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                                case .inputTidakLengkap:
                                    present(genericAlert(titleAlert: "Invalid Input!", messageAlert: "Input Tidak Lengkap, silahkan melengkapi input terlebih dahulu!", buttonText: "Ok"), animated: true)
                                default:
                                    present(genericAlert(titleAlert: "Error!", messageAlert: "Terjadi Kesalahan Dalam Melakukan Pembaharuan Data, Silahkan Coba Lagi", buttonText: "Ok"), animated: true)
                            }
                        }
                    }
                },nil])
            }
        }.disposed(by: bags)
    }
}
