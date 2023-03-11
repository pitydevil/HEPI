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
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
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
        
        //MARK: - Observe Journal Textfield and descriptionTextGView
        Observable.combineLatest(journalTitleTextfield.rx.text.orEmpty, descriptionTextview.rx.text.orEmpty)
            .subscribe(on: MainScheduler.instance)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: writeButtonPressed.rx.isEnabled)
            .disposed(by: bags)
        
        //MARK: - Delete Button Response Function
        deleteButtonPressed.rx.tap.bind { [self] in
            
            //MARK: - Delete Journal Provider Function
            /// Returns summaryGenerate Enumeration
            /// - Parameters:
            ///     - dateCreated: date object that's gonna be passed to the provider, so the provider can query the journal based on the given date.
            popupAlert(title: "Do you want to remove this diary?", message: nil, actionTitles: ["Delete", "Cancel"], actionsStyle: [UIAlertAction.Style.destructive, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                detailJournalViewModel.deleteJournal(journalObject!.value.documentRef!)
            },nil])
        }.disposed(by: bags)
  
        //MARK: - Delete Button Response Function
        detailJournalViewModel.typeErrorObjectObservable.skip(1).subscribe(onNext: { [self] (value) in
            DispatchQueue.main.async { [self] in
                switch value {
                    case .success(let typeSukses):
                        popupAlert(title: "Success", message: "Successfully \(typeSukses) Journal!", actionTitles: ["Okay"], actionsStyle: [UIAlertAction.Style.default], actions: [{ [self] (action1) in
                            navigationController?.popViewController(animated: true)
                        }])
                    case .firebaseError(let firebaseMessage):
                        present(genericAlert(titleAlert: "There's something wrong with the firebase server, please try again later!", messageAlert: "\(firebaseMessage)", buttonText: "Okay"), animated: true)
                    case .inputTidakLengkap:
                        present(genericAlert(titleAlert: "Invalid Input!", messageAlert: "Missing input, do input all of the textfields first!", buttonText: "Okay"), animated: true)
                    default:
                        present(genericAlert(titleAlert: "Error!", messageAlert: "There's something wrong with the firebase server, please try again later!", buttonText: "Okay"), animated: true)
                    }
                }
        }).disposed(by: bags)
        
        
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
                popupAlert(title: "Do you want to save the journal?", message: nil, actionTitles: ["Save", "Cancel"], actionsStyle: [UIAlertAction.Style.default, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                    detailJournalViewModel.addUpdateJournal(journalTitleTextfield.text ?? "", descriptionTextview.text, false, nil)
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
                popupAlert(title: "Do you want to edit this journal?", message: nil, actionTitles: ["Save", "Cancel"], actionsStyle: [UIAlertAction.Style.default, UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                    detailJournalViewModel.addUpdateJournal(journalTitleTextfield.text ?? "", descriptionTextview.text, true, journalObject!.value.documentRef)
                },nil])
            }
        }.disposed(by: bags)
        
        
        
        //MARK: - Detail Journal View Model Update Function
        /// Returns  typeError Enumeration
        /// from the given components.
        refreshButton.rx.tap.bind { [self] in
            journalTitleTextfield.text = nil
            descriptionTextview.text   = nil
        }.disposed(by: bags)
    }
}
