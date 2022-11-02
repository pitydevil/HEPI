//
//  SumaryViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 06/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class SummaryViewModel {
    
    private var provider = BaseProviders()
    private var journalArray: Observable<[Journal]>?
    private let journalModelArray = BehaviorRelay<[Journal]>(value: [])
    
    var dateObject : BehaviorRelay<Date> = BehaviorRelay(value: Date())
    var dateObservable: Observable<Date> {
        return dateObject.asObservable()
    }
    
    var journalModelArrayObserver: Observable<[Journal]> {
        return journalModelArray.asObservable()
    }

    init() {
        self.provider = { return BaseProviders()}()
    }
    
    func getSummaryMood(_ startDate : Date, _ endDate : Date, completion: @escaping(_ result : summaryError) ->Void )  {
        if startDate > endDate || endDate < startDate{
            if startDate > endDate {
                completion(.tanggalLebihMuda(errorMessage: "tanggal mulai lebih tua daripada end date"))
            }else {
                completion(.tanggalLebihTua(errorMessage: "tanggal end date lebih muda daripada start date"))
            }
        }else {
            journalArray = provider.querySummary(startDate, endDate)
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
    
    func calculateSummary(_ journal : [Journal], completion: @escaping(_ result : Result<Summary, summaryGenerate>) ->Void)  {
        if journal.isEmpty {
            completion(.failure(.dataTidakAda(errorMessage: "dataTidakExist")))
        }else {
            var arrayScore = [0,0,0,0,0]
            for item in journal {
                switch item.moodDesc {
                    case "Very Happy":
                        arrayScore[0] += 1
                    case "Happy":
                        arrayScore[1] += 1
                    case "Neutral":
                        arrayScore[2] += 1
                    case "Sad":
                        arrayScore[3] += 1
                    case "Very Sad":
                        arrayScore[4] += 1
                    default:
                        print("error")
                }
            }
            if let maxNumber = arrayScore.max() {
                if let index = arrayScore.firstIndex(where: {$0 == maxNumber}) {
                    switch index {
                    case 0:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "veryHappy")!.pngData(), overallTitleMood: "Your Overall Mood is Very Happy", overallSuggestion: "")))
                    case 1:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "happy")!.pngData(), overallTitleMood: "Your Overall Mood is Happy", overallSuggestion: "")))
                    case 2:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "neutral")!.pngData(), overallTitleMood: "Your Overall Mood is Neutral", overallSuggestion: "")))
                    case 3:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "sad")!.pngData(), overallTitleMood: "Your Overall Mood is Sad", overallSuggestion: "")))
                    case 4:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "verySad")!.pngData(), overallTitleMood: "Your Overall Mood is Very Sad", overallSuggestion: "")))
                    default:
                        print("print?")
                    }
                }else {
                    completion(.failure(.dataTidakAda(errorMessage: "dataTidakExist")))
                }
            }else {
                completion(.success(Summary(overallMoodImage: UIImage(named: "neutral")!.pngData(), overallTitleMood: "Your Overall Mood is Neutral", overallSuggestion: "")))
            }
        }
    }
}
