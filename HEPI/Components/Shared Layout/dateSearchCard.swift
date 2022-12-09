//
//  dateSearchCard.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 09/12/22.
//

import UIKit

class dateSearchCard: UIView {

    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override init(frame : CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    private func loadXib() {
        let viewFromXib = Bundle.main.loadNibNamed("dateSearchCard", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        dateTextfield.setLeftImage("calendar")
        searchButton.titleLabel?.font = .systemFont(ofSize: 19.0, weight: .semibold)
        searchButton.layer.cornerRadius = 8
    }
}
