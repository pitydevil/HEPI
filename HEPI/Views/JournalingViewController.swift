//
//  JournalingViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit
import RxCocoa
import RxSwift

class JournalingViewController: UIViewController {

    @IBOutlet var roundedCard: RoundedCard!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func journalingTapButton(_ sender: Any) {
    }
    
}
