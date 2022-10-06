//
//  JournalingViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit
import RxCocoa
import RxSwift

@available(iOS 16.0, *)
class JournalingViewController: UIViewController {

    @IBOutlet var roundedCard: RoundedCard!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var addButton: UIBarButtonItem!
    
    private let journalViewModel = JournalViewModel()
    private let journalList = BehaviorRelay<[Journal]>(value: [])
    private var detailController : DetailJournalViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        journalViewModel.getAllJournal()
    }
    
    override func viewWillLayoutSubviews() {
        tableView.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailController = UIStoryboard(name: "Journal", bundle: nil).instantiateViewController(identifier: "detailViewController") as DetailJournalViewController
        
        tableView.register(UINib(nibName: "JournalingTableViewCell", bundle: nil), forCellReuseIdentifier: "journalingCell")
        
        //MARK: - Get Misc Information
        welcomeLabel.text = "Welcome, \(journalViewModel.getUsername()) !"
        dateLabel.text    = journalViewModel.getTodayDate()
        
        //MARK: - Observe Journal Array
        journalViewModel.journalModelArrayObserver.subscribe(onNext: { (value) in
            self.journalList.accept(value)
        },onError: { error in
          //  self.errorAlert()
        }).disposed(by: bags)

        //MARK: - Bind Journal List with Table View
        journalList.bind(to: tableView.rx.items(cellIdentifier: "journalingCell", cellType: JournalingTableViewCell.self)) { row, model, cell in
            cell.configureCell(journal: model)
        }.disposed(by: bags)

        //MARK: - Bind Did Select Row with Rx Item Selected
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.detailController?.journalObject = BehaviorRelay(value: Journal())
            self.detailController?.journalObject!.accept(self.journalList.value[indexPath.row])
            self.detailController?.journalObjectObservable.subscribe(onNext: { _ in
                self.tableView.reloadData()
            }).disposed(by: bags)

            self.navigationController?.pushViewController(self.detailController ?? DetailJournalViewController(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Journal Button Pressed
        addButton.rx.tap.bind {
            self.detailController?.journalObject = nil
            self.navigationController?.pushViewController(self.detailController ?? DetailJournalViewController(), animated: true)
        }.disposed(by: bags)
    }
}
