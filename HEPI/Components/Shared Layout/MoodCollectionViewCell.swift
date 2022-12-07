//
//  MoodCollectionViewCell.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

class MoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgCard : UIView!
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var moodDescTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgCard.setBaseRoundedView()
        
        self.backgroundColor = .clear
        self.backgroundView = nil
    }
    
    func configureCell(_ mood : Mood) {
        self.moodImageView.image = UIImage(data: mood.moodImage!)
        self.moodDescTitle.text  = mood.moodDesc!
    }
}
