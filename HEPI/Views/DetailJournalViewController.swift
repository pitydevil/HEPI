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
    @IBOutlet var dateDesc: UILabel!
    @IBOutlet var moodDesc: UILabel!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var writeButtonPressed: UIBarButtonItem!
    @IBOutlet var deleteButtonPressed: UIBarButtonItem!
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var dateRoundedCard: RoundedCard!
    
    //MARK: Computed SubViews Declaration
    @IBOutlet var journalTitleTextfield: UITextField! = {
        let textfield = UITextField()
        textfield.setBaseRoundedView()
        return textfield
    }()
    @IBOutlet var descriptionTextview: UITextView! = {
        let textView = UITextView()
        textView.setBaseRoundedView()
        return textView
    }()
    
    @IBOutlet var moodRoundedCard: UIView!
    
    //MARK: Object Declaration
    private var detailJournalViewModel = DetailJournalViewModel()
    var delegate : sendBackData?
    var moodViewController : MoodViewController?
    var journalObject : BehaviorRelay<Journal>?
    
    //MARK: Object Observer Declaration
    var journalObjectObservable: Observable<Journal> {
        return journalObject?.asObservable() ?? BehaviorRelay(value: Journal()).asObservable()
    }
   
    //MARK: - View Will Layout Subviews
    override func viewWillLayoutSubviews() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(moodTapped(_:)))
        moodRoundedCard.isUserInteractionEnabled = true
        moodRoundedCard.addGestureRecognizer(tapped)
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK: - Register Controller
        moodViewController =  UIStoryboard(name: "Journal", bundle: nil).instantiateViewController(identifier: "feelingController") as MoodViewController
        
        //MARK: Check Journal Object State
        if journalObject != nil {
            deleteButtonPressed.isHidden = false
            
            //MARK: - Observe Journal Object Value
            /// Change UI Object based on journal value
            journalObjectObservable.subscribe(onNext: { [self] (value) in
                dateDesc.text = changeDateIntoStringDate(Date: value.dateCreated!)
                moodDesc.text = value.moodDesc
                journalTitleTextfield.text = value.titleJournal
                descriptionTextview.text   = value.descJournal
                moodImageView.image = UIImage(data: value.moodImage!)
            }).disposed(by: bags)
        }else {
            dateDesc.text                = nil
            moodDesc.text                = nil
            journalTitleTextfield.text   = nil
            descriptionTextview.text     = nil
            moodImageView.image          = nil
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
            detailJournalViewModel.deleteJournal(journalObject!.value.dateCreated!) { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success:
                        present(genericAlert(titleAlert: "Sukses!", messageAlert: "Berhasil Menghapus Jurnal!", buttonText: "Ok"), animated: true)
                        dismissView()
                    case .gagalAddData:
                        present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Menghapus Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                    default:
                        print("gagal")
                    }
                }
            }
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
                detailJournalViewModel.addJournal(journalTitleTextfield.text ?? "", descriptionTextview.text, moodDesc.text ?? "", moodImage: moodImageView.image?.pngData() ?? Data()) { (result) in
                    DispatchQueue.main.async { [self] in
                        switch result {
                            case .success:
                                present(genericAlert(titleAlert: "Sukses!", messageAlert: "Berhasil Menambahkan Jurnal!", buttonText: "Ok"), animated: true)
                                dismissView()
                            case .gagalAddData:
                                present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Penyimpanan Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                            case .inputTidakLengkap:
                                present(genericAlert(titleAlert: "Invalid Input!", messageAlert: "Input Tidak Lengkap, silahkan melengkapi input terlebih dahulu!", buttonText: "Ok"), animated: true)
                            default:
                                present(genericAlert(titleAlert: "Error!", messageAlert: "Terjadi Kesalahan Dalam Melakukan Penyimpanan Data, Silahkan Coba Lagi", buttonText: "Ok"), animated: true)
                            }
                        }
                    }
            }else {
                //MARK: - Detail Journal View Model Update Function
                /// Returns  typeError Enumeration
                /// from the given components.
                /// - Parameters:
                ///     - titleJournal: journal title for the journal title
                ///     - descJournal: journal description for the journal object
                ///     - moodDesc: journal mood description for the journal object
                ///     - moodImage: journal mood image for the journal object
                detailJournalViewModel.updateJournal(journalTitleTextfield.text ?? "", descriptionTextview.text, journalObject!.value.dateCreated! ,moodDesc.text ?? "", moodImage: moodImageView.image?.pngData() ?? Data()) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                            case .success:
                                present(genericAlert(titleAlert: "Sukses!", messageAlert: "Berhasil Mengupdate Jurnal!", buttonText: "Ok"), animated: true)
                                dismissView()
                            case .gagalAddData:
                                present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Pembaharuan Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                            case .inputTidakLengkap:
                                present(genericAlert(titleAlert: "Invalid Input!", messageAlert: "Input Tidak Lengkap, silahkan melengkapi input terlebih dahulu!", buttonText: "Ok"), animated: true)
                            default:
                                present(genericAlert(titleAlert: "Error!", messageAlert: "Terjadi Kesalahan Dalam Melakukan Pembaharuan Data, Silahkan Coba Lagi", buttonText: "Ok"), animated: true)
                        }
                    }
                }
            }
        }.disposed(by: bags)
    }
        
    //MARK: - Journal Button Response Function
    /// Returns boolean true or false
    /// from the given components.
    @objc private func moodTapped(_ gesture : UITapGestureRecognizer) {
        moodViewController?.delegate = self
        present(moodViewController!, animated: true)
    }
    
    //MARK: - Dismiss View to Root View Controller
    /// Dismiss All View to Root View Controller
    private func dismissView() {
        dismiss(animated: true) { [self] in
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

//MARK: - Send Back Data Delegate
@available(iOS 16.0, *)
extension DetailJournalViewController : sendBackData {
    
    //MARK: - Send Back Data Delegate Function
    /// - Parameters:
    ///     - data: generic object that's gonna be converted as Mood
    func sendData<T>(_ data: T) {
        let mood = data as? Mood
        moodDesc.text = mood!.moodDesc
        moodImageView.image = UIImage(data: mood!.moodImage ?? Data())
    }
}
