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


    @IBOutlet weak var moodCollectionView : UICollectionView!
    @IBOutlet weak var arrowRightButton   : UIBarButtonItem!
    
    private var detailJournalViewModel = DetailJournalViewModel()
    private let moodArray = BehaviorRelay<[Mood]>(value: [])
    private var moodViewModel = MoodViewModel()
    
    var delegate : sendBackData?
    
    override func viewWillLayoutSubviews() {
        moodCollectionView.setBaseRoundedView()
        moodCollectionView.setShadowCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodCollectionView.register(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moodCollectionView")
        moodViewModel.fetchMoodData()
        moodViewModel.moodArrayObservable.subscribe(onNext: { (value) in
            self.moodArray.accept(value)
        },onError: { error in
            
        }).disposed(by: bags)
        
        moodArray.bind(to: moodCollectionView.rx.items(cellIdentifier: "moodCollectionView", cellType: MoodCollectionViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)

        moodCollectionView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.delegate?.sendData(self.moodArray.value[indexPath.row])
            self.dismiss(animated: true)
        }).disposed(by: bags)
    }
}


