//
//  QuoteViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 05/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class QuoteViewModel {
    
    //MARK: - Object Declaration
    private let apiService = ApiService()
    private let quoteArray = BehaviorRelay<[Quote]>(value: [])
    var quoteModel : Observable<[WelcomeElement]>?
    
    //MARK: - Object Observation Declaration
    var quoteArrayObserver: Observable<[Quote]> {
        return quoteArray.asObservable()
    }
    
    //MARK: - Fetch Quote Function
    /// Returns array of quotes that's gonna be sent into quote array object observer
    func fetchQuoteList() {
        quoteModel = apiService.callAPI()
        quoteModel?.subscribe(onNext: { (value) in
            var quoteModelArray = [Quote]()
            for index in 0..<value.count {
                let quote = Quote(quotes: value[index].q, author: value[index].a)
                quoteModelArray.append(quote)
            }
            self.quoteArray.accept(quoteModelArray)
        }, onError: { (error) in
            _ = self.quoteArray.catch { (error) in
                Observable.empty()
            }
        }).disposed(by: bags)
    }
}
