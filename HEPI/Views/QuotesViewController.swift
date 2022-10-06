//
//  QuotesViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 05/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class QuotesViewController: UIViewController {
    
    @IBOutlet weak var quoteTableView : UITableView!
    @IBOutlet var quoteActivityIndicator: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    private var quoteViewModel = QuoteViewModel()
    private let apiService = ApiService()
    private let quoteList = BehaviorRelay<[Quote]>(value: [])

    override func viewWillLayoutSubviews() {
        quoteTableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        quoteTableView.addSubview(refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteViewModel.fetchQuoteList()
        quoteTableView.register(UINib(nibName: "QuoteTableViewCell", bundle: nil), forCellReuseIdentifier: "quoteCell")
        
        //MARK: - Observe Quote Array
        quoteViewModel.quoteArrayObserver.subscribe(onNext: { (value) in
            self.quoteList.accept(value)
        },onError: { error in

        }).disposed(by: bags)

        //MARK: - Bind Journal List with Table View
        quoteList.bind(to: quoteTableView.rx.items(cellIdentifier: "quoteCell", cellType: QuoteTableViewCell.self)) { row, model, cell in
            cell.configureCell(quote: model)
            self.quoteActivityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }.disposed(by: bags)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        quoteList.accept([])
        quoteActivityIndicator.startAnimating()
        quoteViewModel.fetchQuoteList()
    }
}

