//
//  Protocol.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift

protocol databaseRequestProtocol {
     func callDatabase<T: Codable>() -> Observable<T>
}

protocol querySummaryProtocol {
    func querySummary<T: Codable>(_ startDate: Date, _ endDate : Date) -> Observable<T>
}

protocol sendBackData {
    func sendData<T> (_ data : T)
}

protocol APIRequestProtocol {
     func callAPI<T: Codable>() -> Observable<T>
}

protocol passData {
    func passData(_ date : Date, _ identifier : datePass)
}
