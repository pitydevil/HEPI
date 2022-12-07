//
//  QuoteTableViewCell.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 05/10/22.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var quoteLabel  : UILabel!
    @IBOutlet weak var authorLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        self.backgroundView = nil
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(quote : Quote) {
        self.quoteLabel.text = quote.quotes
        self.authorLabel.text = quote.author
    }
    
}
