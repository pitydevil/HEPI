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

    @IBOutlet var dateDesc: UILabel!
    @IBOutlet var moodDesc: UILabel!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var writeButtonPressed: UIBarButtonItem!
    @IBOutlet var deleteButtonPressed: UIBarButtonItem!
    @IBOutlet var journalTitleTextfield: UITextField!
    @IBOutlet var moodRoundedCard: UIView!
    @IBOutlet var moodImageView: UIImageView!
    
    @IBOutlet var dateRoundedCard: RoundedCard!
    @IBOutlet var descriptionTextview: UITextView!
    
    private var detailJournalViewModel = DetailJournalViewModel()
    
    var delegate : sendBackData?
    var moodViewController : MoodViewController?
    var journalObject : BehaviorRelay<Journal>?
    var journalObjectObservable: Observable<Journal> {
        return journalObject?.asObservable() ?? BehaviorRelay(value: Journal()).asObservable()
    }
   
    override func viewWillLayoutSubviews() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(moodTapped(_:)))
        moodRoundedCard.isUserInteractionEnabled = true
        moodRoundedCard.addGestureRecognizer(tapped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moodViewController =  UIStoryboard(name: "Journal", bundle: nil).instantiateViewController(identifier: "feelingController") as MoodViewController
        if journalObject != nil {
            deleteButtonPressed.isHidden = false
            journalObjectObservable.subscribe(onNext: { (value) in
                self.dateDesc.text = changeDateIntoStringDate(Date: value.dateCreated!)
                self.moodDesc.text = value.moodDesc
                self.journalTitleTextfield.text = value.titleJournal
                self.descriptionTextview.text   = value.descJournal
                self.moodImageView.image = UIImage(data: value.moodImage!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.journalTitleTextfield.setBaseRoundedView()
        self.descriptionTextview.setBaseRoundedView()
        self.moodRoundedCard.setBaseRoundedView()
        
        if self.journalObject != nil {
            deleteButtonPressed.rx.tap.bind { [self] in
                detailJournalViewModel.deleteJournal(journalObject!.value.dateCreated!) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.present(genericAlert(titleAlert: "Sukses!", messageAlert: "Berhasil Menghapus Jurnal!", buttonText: "Ok"), animated: true)
                            self.dismissView()
                        case .gagalAddData:
                            self.present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Menghapus Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                        default:
                            print("gagal")
                        }
                    }
                }
            }.disposed(by: bags)
        }
        writeButtonPressed.rx.tap.bind { [self] in
            if self.journalObject == nil {
                detailJournalViewModel.addJournal(journalTitleTextfield.text ?? "", descriptionTextview.text, self.moodDesc.text ?? "", moodImage: self.moodImageView.image?.pngData() ?? Data()) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success:
                                self.present(genericAlert(titleAlert: "Sukses!", messageAlert: "Berhasil Menambahkan Jurnal!", buttonText: "Ok"), animated: true)
                                self.dismissView()
                            case .gagalAddData:
                                self.present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Penyimpanan Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                            case .inputTidakLengkap:
                                self.present(genericAlert(titleAlert: "Invalid Input!", messageAlert: "Input Tidak Lengkap, silahkan melengkapi input terlebih dahulu!", buttonText: "Ok"), animated: true)
                            default:
                                self.present(genericAlert(titleAlert: "Error!", messageAlert: "Terjadi Kesalahan Dalam Melakukan Penyimpanan Data, Silahkan Coba Lagi", buttonText: "Ok"), animated: true)
                        }
                    }
                }
            }else {
                detailJournalViewModel.updateJournal(journalTitleTextfield.text ?? "", descriptionTextview.text, self.moodDesc.text ?? "", moodImage: self.moodImageView.image?.pngData() ?? Data()) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success:
                                self.present(genericAlert(titleAlert: "Sukses!", messageAlert: "Berhasil Mengupdate Jurnal!", buttonText: "Ok"), animated: true)
                                self.dismissView()
                            case .gagalAddData:
                                self.present(genericAlert(titleAlert: "Gagal!", messageAlert: "Telah Terjadi Kesalahan Dalam Melakukan Pembaharuan Data, Silahkan Coba Lagi!", buttonText: "Ok"), animated: true)
                            case .inputTidakLengkap:
                                self.present(genericAlert(titleAlert: "Invalid Input!", messageAlert: "Input Tidak Lengkap, silahkan melengkapi input terlebih dahulu!", buttonText: "Ok"), animated: true)
                            default:
                                self.present(genericAlert(titleAlert: "Error!", messageAlert: "Terjadi Kesalahan Dalam Melakukan Pembaharuan Data, Silahkan Coba Lagi", buttonText: "Ok"), animated: true)
                        }
                    }
                }
            }
        }.disposed(by: bags)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    @objc private func moodTapped(_ gesture : UITapGestureRecognizer) {
        self.moodViewController?.delegate = self
        self.present(moodViewController!, animated: true)
    }
    
    private func dismissView() {
        self.dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

@available(iOS 16.0, *)
extension DetailJournalViewController : sendBackData {
    func sendData<T>(_ data: T) {
        let mood = data as? Mood
        self.moodDesc.text = mood!.moodDesc
        self.moodImageView.image = UIImage(data: mood!.moodImage ?? Data())
    }
}
