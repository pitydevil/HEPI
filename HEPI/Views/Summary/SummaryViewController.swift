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
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descTextView : UITextView!
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var dateSearchCard: dateSearchCard!
    
    //MARK: Object Declaration
    private let summaryViewModel = SummaryViewModel()
    private var checkFinalObject = BehaviorRelay<CheckIn>(value:CheckIn(checkInDate: Date(), checkOutDate: Date()))
   
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        descTextView.setBaseRoundedView()
    }
    
    //MARK: - View Did Layout
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Set Touch Responder to Textfield
        dateSearchCard.dateTextfield.addTarget(self, action: #selector(responseTanggal), for: .allTouchEvents)
        
        //MARK: - Delegate Registration
        dateSearchCard.dateTextfield.delegate = self
        
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
                        moodImageView.image = UIImage(data: summary.overallMoodImage ?? Data())
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
        dateSearchCard.searchButton.rx.tap.bind { [self] in
            //MARK: - Summary View Model Get Summary Mood Function
            /// Returns mood summary
            /// from the given components.
            /// - Parameters:
            ///     - startDate: date object that determine starting date for the date interval query
            ///     - endDate: date object that determine ending date for the date interval query
            summaryViewModel.getSummaryMood(checkFinalObject.value.checkInDate, checkFinalObject.value.checkOutDate) { [self] (result) in
                DispatchQueue.main.async { [self] in
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
            }
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

//MARK: - UITextfield Delegate
extension SummaryViewController : UITextFieldDelegate {
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
