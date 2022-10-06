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
    
    private let apiService = ApiService()
    private let quoteArray = BehaviorRelay<[Quote]>(value: [])
    var quoteModel : Observable<[WelcomeElement]>?
    var quoteArrayObserver: Observable<[Quote]> {
        return quoteArray.asObservable()
    }
        
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
            _ = self.quoteArray.catchError { (error) in
                Observable.empty()
            }
        }).disposed(by: bags)
    }
}
