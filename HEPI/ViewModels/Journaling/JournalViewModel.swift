//
//  JournalViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

class JournalViewModel {
    
    //MARK: - Object Declaration
    private var journalArray: Observable<[Journal]>?
    private let journalModelArray = BehaviorRelay<[Journal]>(value: [])
    private var journalErrorObject = BehaviorRelay<String>(value: String())
    
    //MARK: - Object Observation Declaration
    var journalModelArrayObserver: Observable<[Journal]> {
        return journalModelArray.asObservable()
    }
    
    var journalObjectErrorObserver: Observable<String> {
        return journalErrorObject.asObservable()
    }

    //MARK: - Get All Journal Function
    /// Returns array of journal object, that's gonna be pased on journalModelArray observer
    /// from the given components.
    func getAllJournal() {
        baseDiaryDir.whereField("userUUID", isEqualTo: uuidUser ?? "").getDocuments(completion: { [self] querySnapshot, error in
            if error != nil {
                journalErrorObject.accept(String(describing: error))
            }else {
                var journalModel = [Journal]()
                querySnapshot?.documents.forEach({ element in
                    let key = (element.data()["key"] as? String)!
                    let journal = Journal(userUUID: element.data()["userUUID"] as? String, titleJournal: decodeRabbitData((element.data()["titleJournal"] as? String)!, key), moodDesc:  decodeRabbitData((element.data()["moodDesc"] as? String)!, key), descJournal:  decodeRabbitData((element.data()["descJournal"] as? String)!, key), dateCreated: changeDateFromString(dateString: (element.data()["dateCreated"] as? String)!), documentRef: element.documentID, key: key)
                    journalModel.append(journal)
                })
                journalModelArray.accept(journalModel)
            }
        })
    }
    
    //MARK: - Get All Journal Function
    /// Returns array of journal object, that's gonna be pased on journalModelArray observer
    /// from the given components.
    func getSummaryMood(_ startDate : Date, _ endDate : Date) {
        if startDate > endDate || endDate < startDate{
            if startDate > endDate {
                journalErrorObject.accept("Tanggal awal lebih tua daripada tanggal akhir")
            }else {
                journalErrorObject.accept("Tanggal akhir lebih muda daripada tanggal awal")
            }
        }else {
            baseDiaryDir.whereField("userUUID", isEqualTo: uuidUser ?? "").getDocuments(completion: { [self] querySnapshot, error in
                if error != nil {
                    journalErrorObject.accept(String(describing: error))
                }else {
                    var journalModel = [Journal]()
                    querySnapshot?.documents.forEach({ element in
                        let key = (element.data()["key"] as? String)!
                        let journal = Journal(userUUID: element.data()["userUUID"] as? String, titleJournal: decodeRabbitData((element.data()["titleJournal"] as? String)!, key), moodDesc:  decodeRabbitData((element.data()["moodDesc"] as? String)!, key), descJournal:  decodeRabbitData((element.data()["descJournal"] as? String)!, key), dateCreated: changeDateFromString(dateString: (element.data()["dateCreated"] as? String)!), documentRef: element.documentID, key: key)
                        if journal.dateCreated! >= startDate && journal.dateCreated! <= endDate {
                            journalModel.append(journal)
                        }
                    })
                    journalModelArray.accept(journalModel)
                }
            })
        }
    }
}
