//
//  JournalingTableViewCell.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

class JournalingTableViewCell: UITableViewCell {

    
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet weak var journalDateLabel: UILabel!
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var bgCard : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgCard.setBaseRoundedView()
        self.bgCard.setShadowCard()
        
        self.backgroundColor = .clear
        self.backgroundView = nil
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(journal : Journal) {
        self.journalTitleLabel.text = journal.titleJournal
        self.journalDateLabel.text  = changeDateIntoStringDate(Date: journal.dateCreated!)
        self.moodImageView.image    = UIImage(data: journal.moodImage!)
    }
}
