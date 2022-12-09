//
//  JournalingTableViewCell.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit

class JournalingTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleCard: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet weak var journalDateLabel: UILabel!
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var bgCard : UIView!
    @IBOutlet weak var imageCard: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.bgCard.setBaseRoundedView()
        self.bgCard.setShadowCard()
        self.subtitleCard.clipsToBounds = true
        self.imageCard.clipsToBounds = true
        self.imageCard.setBaseRoundedView()
        self.subtitleCard.setBaseRoundedView()
        //minxminy = atas kiri
        //minxmaxy = bawah kiri
        
        self.imageCard.layer.maskedCorners = [.layerMinXMaxYCorner ,.layerMaxXMinYCorner]
        self.subtitleCard.layer.maskedCorners = [ .layerMaxXMaxYCorner]
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
