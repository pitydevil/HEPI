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

    //MARK: - Layout Subviews
    @IBOutlet weak var leftDateCard : TextfieldCard!
    @IBOutlet weak var rightDateCard : TextfieldCard!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var summaryImage : UIImageView!
    @IBOutlet weak var descTextView : UITextView!
    @IBOutlet weak var searchButton : UIBarButtonItem!
    
    //MARK: Object Declaration
    private var startDate = Date()
    private var endDate   = Date()
    private let summaryViewModel = SummaryViewModel()
   
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        leftDateCard?.delegate = self
        rightDateCard?.delegate = self
        leftDateCard.identifier = .start
        rightDateCard.identifier = .end
    }
    
    //MARK: - View Did Layout
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Responder to Dismiss any Keyboard Event
        hideKeyboardWhenTappedAround()
        
        //MARK: - Observe Summary View Model Journal Object Value
        /// Observe Summary View Model Journal Object Value, if there are ny changes update the neccessary UI.
        summaryViewModel.journalModelArrayObserver.skip(1).subscribe(onNext: { [self] (value) in
            //MARK: - Summary View Model Calculate Summary
            /// Returns Summary Object that's used to update the neccessary UI.
            /// - Parameters:
            ///     - journalList: array of journal thatt the function will use to determine mood summary.
            summaryViewModel.calculateSummary(value) { (result) in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let summary):
                        summaryImage.image = UIImage(data: summary.overallMoodImage ?? Data())
                        descTextView.text  = summary.overallSuggestion ?? ""
                        titleLabel.text    = summary.overallTitleMood ?? ""
                    case .failure(_):
                        present(genericAlert(titleAlert: "Data Inkonklusif!", messageAlert: "Data yang diberikan tidak dapat ditarik kesimpulan.", buttonText: "Ok"), animated: true)
                    }
                }
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        
        //MARK: - Search Button Response Function
        searchButton.rx.tap.bind { [self] in
            //MARK: - Summary View Model Get Summary Mood Function
            /// Returns mood summary
            /// from the given components.
            /// - Parameters:
            ///     - startDate: date object that determine starting date for the date interval query
            ///     - endDate: date object that determine ending date for the date interval query
            summaryViewModel.getSummaryMood(startDate, endDate) { [self] (result) in
                switch result {
                case .dataTidakAda(errorMessage: ""):
                    present(genericAlert(titleAlert: "Data Tidak Ada!", messageAlert: "Kamu tidak membuat journal direntang hari tersebut.", buttonText: "Ok"), animated: true)
                case .tanggalLebihTua(errorMessage: ""):
                    present(genericAlert(titleAlert: "Tanggal Tidak Valid!", messageAlert: "Tanggal Akhir tidak bisa lebih muda daripada tanggal awalannya.", buttonText: "Ok"), animated: true)
                case .tanggalLebihMuda(errorMessage: ""):
                    present(genericAlert(titleAlert: "Tanggal Tidak Valid!", messageAlert: "Tanggal awal tidak bisa lebih tua daripada tanggal akhirannya.", buttonText: "Ok"), animated: true)
                default:
                    print("test")
                }
            }
        }.disposed(by: bags)
    }
}

//MARK: - Pass Data Delegate Function
/// Returns boolean true or false
/// from the given components.
extension SummaryViewController : passData {
    //MARK: - Observe Journal Array
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    ///     - text: set of character/string that would like  to be checked.
    func passData(_ date: Date, _ identifier: datePass) {
        switch identifier {
            case .end:
                self.endDate  = date
            case .start:
                self.startDate = date
        }
    }
}
