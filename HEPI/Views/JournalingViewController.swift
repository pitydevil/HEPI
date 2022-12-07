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

    //MARK: - Layout Subviews
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var roundedCard: RoundedCard!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var addButton: UIBarButtonItem!
    
    //MARK: Object Declaration
    private let journalViewModel = JournalViewModel()
    private let journalList = BehaviorRelay<[Journal]>(value: [])
    private var detailController : DetailJournalViewController?
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        journalViewModel.getAllJournal()
    }
    
    //MARK: - View Will Layout Subviews
    override func viewWillLayoutSubviews() {
        tableView.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Register Controller
        detailController = UIStoryboard(name: "Journal", bundle: nil).instantiateViewController(identifier: "detailViewController") as DetailJournalViewController
        
        //MARK: - Register TableView
        tableView.register(UINib(nibName: "JournalingTableViewCell", bundle: nil), forCellReuseIdentifier: "journalingCell")
        
        //MARK: - Get Misc Information from ViewModel
        welcomeLabel.text = "Welcome, \(journalViewModel.getUsername()) !"
        dateLabel.text    = journalViewModel.getTodayDate()
        
        //MARK: - Observe Journal Array
        /// Observe journal view model's journal array in case there's any changes, and will update array of journal if there are any changes
        journalViewModel.journalModelArrayObserver.subscribe(onNext: { [self] (value) in
            journalList.accept(value)
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)

        //MARK: - Bind Journal List with Table View
        /// Bind journal list with journalingTableView
        journalList.bind(to: tableView.rx.items(cellIdentifier: "journalingCell", cellType: JournalingTableViewCell.self)) { row, model, cell in
            cell.configureCell(journal: model)
        }.disposed(by: bags)

        //MARK: - Bind Did Select Row with Rx Item Selected
        /// TableView Did Select delegate function and response accordingnly.
        tableView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
            tableView.deselectRow(at: indexPath, animated: true)
            detailController?.journalObject = BehaviorRelay(value: Journal())
            detailController?.journalObject!.accept(journalList.value[indexPath.row])
            detailController?.journalObjectObservable.subscribe(onNext: { [self] _ in
                tableView.reloadData()
            }).disposed(by: bags)
            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Journal Button Response Function
        /// Segue to Detail Journal View Controller.
        addButton.rx.tap.bind { [self] in
            detailController?.journalObject = nil
            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }.disposed(by: bags)
    }
}
