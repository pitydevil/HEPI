//
//  JournalViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class JournalViewModel {
    
    private var provider = BaseProviders()
    
    private var journalArray: Observable<[Journal]>?
    private let journalModelArray = BehaviorRelay<[Journal]>(value: [])
    var journalModelArrayObserver: Observable<[Journal]> {
        return journalModelArray.asObservable()
    }

    init() {
        self.provider = { return BaseProviders()}()
    }

    func getTodayDate() -> String {
       return changeDateIntoStringDate(Date: Date())
    }
    
    func getUsername() -> String{
        return defaults.string(forKey: nameKeys) ?? ""
    }
    
    func getAllJournal() {
        journalArray = provider.callDatabase()
        journalArray?.subscribe(onNext: { (value) in
            var journalModel = [Journal]()
            for index in 0..<value.count {
                let user = value[index]
                journalModel.append(user)
            }
            self.journalModelArray.accept(journalModel)
        }, onError: { (error) in
            _ = self.journalModelArrayObserver.catchError { (error) in
                Observable.empty()
            }
        }).disposed(by: bags)
    }
}
