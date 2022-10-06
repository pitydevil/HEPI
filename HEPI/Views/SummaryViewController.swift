//
//  SummaryViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 06/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class SummaryViewController: UIViewController {

    @IBOutlet weak var leftDateCard : TextfieldCard!
    @IBOutlet weak var rightDateCard : TextfieldCard!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var summaryImage : UIImageView!
    @IBOutlet weak var descTextView : UITextView!
    @IBOutlet weak var searchButton : UIBarButtonItem!
    
    private var startDate = Date()
    private var endDate   = Date()
    private let summaryViewModel = SummaryViewModel()
   
    override func viewWillAppear(_ animated: Bool) {
        leftDateCard?.delegate = self
        leftDateCard.identifier = .start
        rightDateCard?.delegate = self
        rightDateCard.identifier = .end
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        summaryViewModel.journalModelArrayObserver.skip(1).subscribe(onNext: { (value) in
            self.summaryViewModel.calculateSummary(value) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let summary):
                        print("kesini?")
                        self.summaryImage.image = UIImage(data: summary.overallMoodImage ?? Data())
                        self.descTextView.text  = summary.overallSuggestion ?? ""
                        self.titleLabel.text    = summary.overallTitleMood ?? ""
                    case .failure(_):
                        self.present(genericAlert(titleAlert: "Data Inkonklusif!", messageAlert: "Data yang diberikan tidak dapat ditarik kesimpulan.", buttonText: "Ok"), animated: true)
                    }
                }
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        searchButton.rx.tap.bind {
            self.summaryViewModel.getSummaryMood(self.startDate, self.endDate) { result in
                switch result {
                case .dataTidakAda(errorMessage: ""):
                    self.present(genericAlert(titleAlert: "Data Tidak Ada!", messageAlert: "Kamu tidak membuat journal direntang hari tersebut.", buttonText: "Ok"), animated: true)
                case .tanggalLebihTua(errorMessage: ""):
                    self.present(genericAlert(titleAlert: "Tanggal Tidak Valid!", messageAlert: "Tanggal Akhir tidak bisa lebih muda daripada tanggal awalannya.", buttonText: "Ok"), animated: true)
                case .tanggalLebihMuda(errorMessage: ""):
                    self.present(genericAlert(titleAlert: "Tanggal Tidak Valid!", messageAlert: "Tanggal awal tidak bisa lebih tua daripada tanggal akhirannya.", buttonText: "Ok"), animated: true)
                default:
                    print("test")
                }
            }
        }.disposed(by: bags)
    }
}

extension SummaryViewController : passData {
    func passData(_ date: Date, _ identifier: datePass) {
        switch identifier {
            case .end:
                self.endDate  = date
            case .start:
                self.startDate = date
        }
    }
}
