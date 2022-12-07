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
    
    //MARK: - Object Declaration
    private var provider = BaseProviders()
    private var journalArray: Observable<[Journal]>?
    private let journalModelArray = BehaviorRelay<[Journal]>(value: [])
    
    //MARK: - Object Observation Declaration
    var journalModelArrayObserver: Observable<[Journal]> {
        return journalModelArray.asObservable()
    }

    //MARK: - Init Class
    init() {
        self.provider = { return BaseProviders()}()
    }

    //MARK: - Get Today Date Function
    /// Returns today date
    /// from the given components.
    func getTodayDate() -> String {
       return changeDateIntoStringDate(Date: Date())
    }
    
    //MARK: - Get Username Function
    /// Returns current user's username from userDefaults
    /// from the given components.
    func getUsername() -> String{
        return defaults.string(forKey: nameKeys) ?? ""
    }
    
    //MARK: - Get All Journal Function
    /// Returns array of journal object, that's gonna be pased on journalModelArray observer
    /// from the given components.
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
            _ = self.journalModelArrayObserver.catch { (error) in
                Observable.empty()
            }
        }).disposed(by: bags)
    }
}
