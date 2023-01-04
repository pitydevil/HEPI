//
//  ReuseableLabel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

class ReuseableLabel: UILabel {
    
    enum labelTypeEnum {
        case titleH1
        case bodyP2
    }
    
    enum colorStyle {
        case primaryMain
        case black
        case grey
    }
    
    public private(set) var labelType: labelTypeEnum
    public private(set) var labelText: String
    public private(set) var labelColor: colorStyle
    
    init(labelText: String, labelType: labelTypeEnum, labelColor: colorStyle) {
        self.labelText = labelText
        self.labelType = labelType
        self.labelColor = labelColor
        
        super.init(frame: .zero)
        self.configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        self.configureLabelStyle()
        self.configureLabelColor()
    }
    
    private func configureLabelColor() {
        switch labelColor {
        case .primaryMain:
            self.textColor = UIColor(named: "primaryMain")
        case .black:
            self.textColor = UIColor(named: "primaryMain")
        case .grey:
            self.textColor = UIColor(named: "primaryMain")
        }
    }
    
    private func configureLabelStyle() {
        switch labelType {
        case .titleH1:
            self.font  = UIFont.systemFont(ofSize: 16, weight: .bold)
        case .bodyP2:
            self.font  = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textAlignment = .left
        let attributedString = NSMutableAttributedString(string: labelText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
