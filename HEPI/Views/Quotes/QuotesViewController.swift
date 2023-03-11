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
    
    //MARK: - Layout Subviews
    @IBOutlet weak var quoteTableView : UITableView!
    @IBOutlet var quoteActivityIndicator: UIActivityIndicatorView!
    private lazy var refreshControl:  UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - Object Declaration
    private let quoteList = BehaviorRelay<[Quote]>(value: [])
    private var quoteViewModel = QuoteViewModel()

    //MARK: - View Will Layoyt Subviews
    override func viewWillLayoutSubviews() {
        quoteTableView.separatorStyle = .none
        quoteTableView.addSubview(refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Fetch Quote from Endpoint
        /// Returns boolean true or false
        /// from the given components.
        quoteViewModel.fetchQuoteList()
        quoteActivityIndicator.startAnimating()
        
        //MARK: - Register Quote TableView with quoteCell
        quoteTableView.register(UINib(nibName: "QuoteTableViewCell", bundle: nil), forCellReuseIdentifier: "quoteCell")
        
        //MARK: - Quote Array Observer
        /// Observe Quote View Model 's quote Array, if there are any changes update quoteList array value
        quoteViewModel.quoteArrayObserver.subscribe(onNext: { [self] (value) in
            quoteList.accept(value)
        },onError: { error in
            self.present(errorAlert(), animated: true) 
        }).disposed(by: bags)

        //MARK: - Bind Quote List to Quote TableView
        /// Bind Quote Array with Quote Table View.
        quoteList.bind(to: quoteTableView.rx.items(cellIdentifier: "quoteCell", cellType: QuoteTableViewCell.self)) {[self] (row, model, cell) in
            cell.configureCell(quote: model)
            quoteActivityIndicator.stopAnimating()
            refreshControl.endRefreshing()
        }.disposed(by: bags)
    }
    
    //MARK: - Refresh Response Function
    /// Response when refresh control is pulled
    @objc func refresh(_ sender: AnyObject) {
        quoteList.accept([])
        quoteViewModel.fetchQuoteList()
    }
}

