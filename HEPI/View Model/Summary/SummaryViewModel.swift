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
    
    //MARK: - Object Declaration
    private var provider = BaseProviders()
    private var journalArray: Observable<[Journal]>?
    private let journalModelArray = BehaviorRelay<[Journal]>(value: [])
    var dateObject : BehaviorRelay<Date> = BehaviorRelay(value: Date())
    
    //MARK: - Object Observation Declaration
    var dateObservable: Observable<Date> {
        return dateObject.asObservable()
    }
    
    var journalModelArrayObserver: Observable<[Journal]> {
        return journalModelArray.asObservable()
    }

    //MARK: - Init Class
    init() {
        self.provider = { return BaseProviders()}()
    }
    
    //MARK: - Get Mood Summary Function
    /// Returns Summary Error Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - startDate: date object that determine starting date for the date interval query
    ///     - endDate: date object that determine ending date for the date interval query
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
                _ = self.journalModelArrayObserver.catch { (error) in
                    Observable.empty()
                }
            }).disposed(by: bags)
        }
    }
    
    //MARK: - Calculate Summary Function
    /// Returns object of summary struct and summaryGenerate Enumeration
    /// from the given components.
    /// - Parameters:
    ///     - journal: array of journal to get the summary off
    func calculateSummary(_ journal : [Journal], completion: @escaping(_ result : Result<Summary, summaryGenerate>) ->Void)  {
        if journal.isEmpty {
            completion(.failure(.dataTidakAda(errorMessage: "dataTidakExist")))
        }else {
            var arrayScore = [0,0,0,0,0,0]
            for item in journal {
                switch item.moodDesc {
                    case "Anger":
                        arrayScore[0] += 1
                    case "Fear":
                        arrayScore[1] += 1
                    case "Joy":
                        arrayScore[2] += 1
                    case "Love":
                        arrayScore[3] += 1
                    case "Neutral":
                        arrayScore[4] += 1
                    case "Sad":
                        arrayScore[5] += 1
                    default:
                        print("error")
                }
            }
            if let maxNumber = arrayScore.max() {
                if let index = arrayScore.firstIndex(where: {$0 == maxNumber}) {
                    switch index {
                    case 0:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "Anger")!.pngData(), overallTitleMood: "Anger", overallSuggestion: "")))
                    case 1:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "Fear")!.pngData(), overallTitleMood: "Fear", overallSuggestion: "")))
                    case 2:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "Joy")!.pngData(), overallTitleMood: "Joy", overallSuggestion: "")))
                    case 3:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "Love")!.pngData(), overallTitleMood: "Love", overallSuggestion: "")))
                    case 4:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "Neutral")!.pngData(), overallTitleMood: " Neutral", overallSuggestion: "")))
                    case 5:
                        completion(.success(Summary(overallMoodImage: UIImage(named: "Sad")!.pngData(), overallTitleMood: "Sad", overallSuggestion: "")))
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
