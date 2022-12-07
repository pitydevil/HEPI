//
//  MoodViewController.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import UIKit
import RxSwift
import RxCocoa

@available(iOS 16.0, *)
class MoodViewController: UIViewController {

    //MARK: - Layout Subviews
    @IBOutlet weak var moodCollectionView : UICollectionView!
    @IBOutlet weak var arrowRightButton   : UIBarButtonItem!
    
    //MARK: Object Declaration
    private let moodArray = BehaviorRelay<[Mood]>(value: [])
    private var detailJournalViewModel = DetailJournalViewModel()
    private var moodViewModel = MoodViewModel()
    var delegate : sendBackData?
    
    //MARK: - View Will Layout Subviews
    override func viewWillLayoutSubviews() {
        moodCollectionView.setBaseRoundedView()
        moodCollectionView.setShadowCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Register CollectionView
        moodCollectionView.register(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moodCollectionView")
        
        //MARK: - Fetch Data from View Model
        moodViewModel.fetchMoodData()
        
        //MARK: - Observe Journal Array
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        moodViewModel.moodArrayObservable.subscribe(onNext: { [self] (value) in
            moodArray.accept(value)
        },onError: { error in
            self.present(errorAlert(), animated: true) 
        }).disposed(by: bags)
        
        //MARK: - Observe Journal Array
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        moodArray.bind(to: moodCollectionView.rx.items(cellIdentifier: "moodCollectionView", cellType: MoodCollectionViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)

        //MARK: - Observe Journal Array
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        moodCollectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
            delegate?.sendData(moodArray.value[indexPath.row])
            dismiss(animated: true)
        }).disposed(by: bags)
    }
}


