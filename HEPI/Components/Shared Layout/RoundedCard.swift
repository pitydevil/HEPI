//
//  RoundedCard.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

class RoundedCard: UIView {

    @IBOutlet weak var upperTextLabel : UILabel!
    @IBOutlet weak var lowerTextLabel : UILabel!
    @IBOutlet weak var bgCard         : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackground()
        loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    private func setBackground() {
        self.bgCard.setBaseRoundedView()
    }
    
    private func loadXib() {
        let viewFromXib = Bundle.main.loadNibNamed("RoundedCard", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
       
    }
}
