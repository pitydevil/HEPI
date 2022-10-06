//
//  DetailJournalViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class DetailJournalViewModel {
    
    var moodObject : BehaviorRelay<Mood> = BehaviorRelay<Mood>(value: Mood())
    var moodObjectObservable : Observable<Mood> {
        return moodObject.asObservable()
    }
    private var provider = BaseProviders()

    init() {
        self.provider = { return BaseProviders()}()
    }
        
    func addJournal(_ titleJournal : String, _ descJournal : String, _ moodDesc : String, moodImage : Data? , completion: @escaping(_ result: typeError)-> Void ) {
        if titleJournal.count != 0 && descJournal.count != 0 && moodImage != Data() {
            provider.addJournal(titleJournal, descJournal, Date(), moodImage!, moodDesc) { result in
                switch result {
                    case true:
                        completion(.success)
                    case false:
                        completion(.gagalAddData)
                }
            }
        }else {
            completion(.inputTidakLengkap)
        }
    }
    
    func updateJournal(_ titleJournal : String, _ descJournal : String, _ moodDesc : String, moodImage : Data? , completion: @escaping(_ result: typeError)-> Void ) {
        if titleJournal.count != 0 && descJournal.count != 0 && moodImage != Data() {
            provider.updateExisting(titleJournal, descJournal, Date(), moodImage!, moodDesc) { result in
                switch result {
                    case true:
                        completion(.success)
                    case false:
                        completion(.gagalAddData)
                }
            }
        }else {
            completion(.inputTidakLengkap)
        }
    }
    
    
    func deleteJournal(_ dateCreated : Date , completion: @escaping(_ result: typeError)-> Void ) {
        provider.deleteJournal(dateCreated) { result in
            switch result {
                case true:
                    completion(.success)
                case false:
                    completion(.gagalAddData)
            }
        }
    }
}
