//
//  DetailJournalViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import CryptoSwift

class DetailJournalViewModel {
    
    //MARK: - Object Declaration
    private var typeErrorObject : BehaviorRelay<typeError> = BehaviorRelay(value: typeError.gagalAddData)
    
    //MARK: - Object Observation Declaration
    var typeErrorObjectObservable: Observable<typeError> {
        return typeErrorObject.asObservable()
    }
    
    //MARK: - Add Journal Function
    /// Returns  typeError Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - titleJournal: journal title for the journal title
    ///     - descJournal: journal description for the journal object
    ///     - moodDesc: journal mood description for the journal object
    ///     - moodImage: journal mood image for the journal object
    func addUpdateJournal(_ titleJournal : String, _ descJournal : String, _ isUpdate : Bool, _ documentRefID : String? ) {
        if titleJournal.count != 0 && descJournal.count != 0 {
            //MARK: - Add Journal Provider Function
            /// Returns summaryGenerate enumeration
            /// from the given components.
            /// - Parameters:
            ///     - titleJournal:  journal title for the journal title
            ///     - descJournal: journal description for the journal object
            ///     - moodDesc: journal mood description for the journal object
            ///     - moodImage: journal mood image for the journal object
            ///     - dateCreated: journal date creatiion for the journal object
            let classifiedMood = String(describing: classify(text: descJournal))
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let randomStri = randomKeyString(length: 16)
                let mainData : [String : Any] = [
                    "userUUID" : String(uuidUser ?? ""),
                    "titleJournal" : encodeRabbitData(titleJournal, randomStri)!,
                    "descJournal" : encodeRabbitData(descJournal, randomStri)!,
                    "moodDesc" : encodeRabbitData(classifiedMood, randomStri)!,
                    "key"      : randomStri,
                    "dateCreated" : createTodayObject()
                ]
                
                if isUpdate {
                    transaction.updateData(mainData, forDocument: baseDiaryDir.document(documentRefID ?? ""))
                }else {
                    transaction.setData(mainData, forDocument: baseDiaryDir.document())
                }
                return nil
            }) { [self] (object, error) in
                 if error != nil {
                     typeErrorObject.accept(.firebaseError(firebaseMessage: error?.localizedDescription ?? ""))
                 } else {
                     if isUpdate {
                         typeErrorObject.accept(.success(typeMessage: "Mengupdate"))
                     }else {
                         typeErrorObject.accept(.success(typeMessage: "Menambahkan"))
                     }
                 }
             }
        }else {
            typeErrorObject.accept(.inputTidakLengkap)
        }
    }
    
    //MARK: - Delete Journal Function
    /// Returns typeError Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - dateCreated: date object that's gonna be used as the main query for the nspredicate object on provider delete function
    func deleteJournal(_ documentRef : String) {
        //MARK: - Provider Delete Journal Function
        /// Returns summaryGeneration Enumeration
        /// from the given components.
        /// - Parameters:
        ///     - dateCreated: date object that's gonna be used as the main query for the nspredicate object on provider delete function
        db.runTransaction({ (transaction, errorPointer) -> Any? in
             transaction.deleteDocument(baseDiaryDir.document(documentRef))
             return nil
        }) { [self] (object, error) in
             if error != nil {
                 typeErrorObject.accept(.firebaseError(firebaseMessage: error?.localizedDescription ?? ""))
             } else {
                 typeErrorObject.accept(.success(typeMessage: "Menghapus"))
             }
         }
    }
    
    //MARK: - Classify Function
    /// Returns  emotionCase Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - text: description that's gonna be classified by tensorflowLite Model.
    private func classify(text: String) -> emotionCase {
        var emotion : emotionCase = .Neutral
        let classifierResults = classifier!.classify(text: text)
        let result = ClassificationResult(text: text, results: classifierResults)
        
        var keyArray = [String]()
        var valueArray = [Double]()
        
        for (key, value) in result.results {
            keyArray.append(key)
            valueArray.append(value as! Double)
        }
        
        if let (maxIndex, _) = valueArray.enumerated().max(by: { $0.element < $1.element}) {
            emotion = emotionCase(rawValue: keyArray[maxIndex]) ?? .Neutral
        }
        return emotion
    }
}
