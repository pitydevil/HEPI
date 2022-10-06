//
//  TextfieldCard.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 06/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class TextfieldCard: UIView {
    
    @IBOutlet weak var bgCard : UIView!
    @IBOutlet weak var dateTextfield : UITextField!
    
    private var datePicker :UIDatePicker!
    private let summaryViewModel = SummaryViewModel()
    
    var delegate : passData?
    var identifier  : datePass = .start
    
    override init(frame : CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    private func configureTextfield() {
        dateTextfield.delegate = self
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 200))
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        dateTextfield.inputView = datePicker
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        dateTextfield.inputAccessoryView = toolBar
    }

    private func loadXib() {
        let viewFromXib = Bundle.main.loadNibNamed("TextfieldCard", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        configureTextfield()
        self.bgCard.setBaseRoundedView()
    }
    
    @objc func datePickerDone() {
        dateTextfield.resignFirstResponder()
    }
    
    @objc func dateChanged(){
        delegate?.passData(self.datePicker.date, identifier)
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "dd MMM"
        dateTextfield.text = dateFormater.string(from: self.datePicker.date) as String
    }
}
extension TextfieldCard : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("test")
        return false
    }
}
