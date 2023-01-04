//
//  ReusableTabBar.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 07/10/22.
//

import UIKit

class ReusableTabBar: UIView {

    var barBtn = ReusableButton(titleBtn: "", styleBtn: .normal)
    
    private let pilihSemuaText = ReuseableLabel(labelText: "Pilih Semua", labelType: .bodyP2, labelColor: .primaryMain)
    private let hewanDipilih = ReuseableLabel(labelText: "Semua hewan dipilih", labelType: .bodyP2, labelColor: .grey)
    private let lineView = UIView()
    
    private let boxBtn = UIButton()
    private let checkedImage = UIImage(systemName: "checkmark.square.fill")
    private let uncheckedImage = UIImage(systemName: "square")
    private var isChecked = false
    
    enum textBox {
        case notShow
    }
    
    public private(set) var btnText: String
    public private(set) var showText: textBox
    
    init(btnText: String, showText: textBox) {
        self.btnText = btnText
        self.showText = showText
        
        super.init(frame: .zero)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        switch showText {
            case .notShow:
                pilihSemuaText.text = ""
                hewanDipilih.text = ""
                boxBtn.setImage(UIImage(), for: .normal)
        }
        
        barBtn.configuration?.attributedTitle = AttributedString(btnText, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)]))
        
        lineView.backgroundColor = UIColor(named: "grey2")
        
        //MARK: - Set View Background
        self.backgroundColor = UIColor.white
        
        //MARK: - Add SubView
        self.addSubview(barBtn)
        self.addSubview(pilihSemuaText)
        self.addSubview(hewanDipilih)
        self.addSubview(boxBtn)
        self.addSubview(lineView)
        
        //MARK: - Set Auto False
        self.translatesAutoresizingMaskIntoConstraints = false
        barBtn.translatesAutoresizingMaskIntoConstraints = false
        pilihSemuaText.translatesAutoresizingMaskIntoConstraints = false
        hewanDipilih.translatesAutoresizingMaskIntoConstraints = false
        boxBtn.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Setup Constraint
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 92),
            
            barBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            barBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            hewanDipilih.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            hewanDipilih.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            boxBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            boxBtn.topAnchor.constraint(equalTo: hewanDipilih.bottomAnchor, constant: 4),
            
            pilihSemuaText.leadingAnchor.constraint(equalTo: boxBtn.trailingAnchor, constant: 8),
            pilihSemuaText.topAnchor.constraint(equalTo: hewanDipilih.bottomAnchor, constant: 4),
            pilihSemuaText.centerYAnchor.constraint(equalTo: boxBtn.centerYAnchor),
            
            lineView.topAnchor.constraint(equalTo: self.topAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 500),
            lineView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
