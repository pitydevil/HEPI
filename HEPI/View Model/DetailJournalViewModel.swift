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
    
    //MARK: - Object Declaration
    private var provider = BaseProviders()
    var moodObject : BehaviorRelay<Mood> = BehaviorRelay<Mood>(value: Mood())
    
    //MARK: - Object Observation Declaration
    var moodObjectObservable : Observable<Mood> {
        return moodObject.asObservable()
    }

    //MARK: - Init Class
    init() {
        self.provider = { return BaseProviders()}()
    }
        
    //MARK: - Add Journal Function
    /// Returns  typeError Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - titleJournal: journal title for the journal title
    ///     - descJournal: journal description for the journal object
    ///     - moodDesc: journal mood description for the journal object
    ///     - moodImage: journal mood image for the journal object
    func addJournal(_ titleJournal : String, _ descJournal : String, _ moodDesc : String, moodImage : Data? , completion: @escaping(_ result: typeError)-> Void ) {
        if titleJournal.count != 0 && descJournal.count != 0 && moodImage != Data() {
            
            //MARK: - Add Journal Provider Function
            /// Returns summaryGenerate enumeration
            /// from the given components.
            /// - Parameters:
            ///     - titleJournal:  journal title for the journal title
            ///     - descJournal: journal description for the journal object
            ///     - moodDesc: journal mood description for the journal object
            ///     - moodImage: journal mood image for the journal object
            ///     - dateCreated: journal date creatiion for the journal object
            provider.addJournal(titleJournal, descJournal, Date(), moodImage!,String(describing: classify(text: descJournal))) { result in
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
    
    //MARK: - Update Journal Function
    /// Returns  typeError Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - titleJournal: journal title for the journal title
    ///     - descJournal: journal description for the journal object
    ///     - moodDesc: journal mood description for the journal object
    ///     - moodImage: journal mood image for the journal object
    func updateJournal(_ titleJournal : String, _ descJournal : String, _ date : Date ,_ moodDesc : String, moodImage : Data? , completion: @escaping(_ result: typeError)-> Void ) {
        if titleJournal.count != 0 && descJournal.count != 0 && moodImage != Data() {
            //MARK: - Update Existing Provider Function
            /// Returns summaryGenerate enumeration
            /// from the given components.
            /// - Parameters:
            ///     - titleJournal:  journal title for the journal title
            ///     - descJournal: journal description for the journal object
            ///     - moodDesc: journal mood description for the journal object
            ///     - moodImage: journal mood image for the journal object
            ///     - dateCreated: journal date creatiion for the journal object
            provider.updateExisting(titleJournal, descJournal, date, moodImage!, String(describing: classify(text: descJournal))) { result in
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
    
    //MARK: - Delete Journal Function
    /// Returns typeError Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - dateCreated: date object that's gonna be used as the main query for the nspredicate object on provider delete function
    func deleteJournal(_ dateCreated : Date , completion: @escaping(_ result: typeError)-> Void ) {
        //MARK: - Provider Delete Journal Function
        /// Returns summaryGeneration Enumeration
        /// from the given components.
        /// - Parameters:
        ///     - dateCreated: date object that's gonna be used as the main query for the nspredicate object on provider delete function
        provider.deleteJournal(dateCreated) { result in
            switch result {
                case true:
                    completion(.success)
                case false:
                    completion(.gagalAddData)
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
