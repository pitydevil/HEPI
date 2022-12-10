//
//  Api Services.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 03/10/22.
//

import Foundation
import RxCocoa
import RxSwift

class ApiService : APIRequestProtocol {
    
    private let baseURL = URL(string: "https://zenquotes.io/api/quotes")!
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask? = nil
    
    func callAPI<T>() -> Observable<T> where T : Decodable, T : Encodable {
        return Observable<T>.create { observer in
            self.dataTask = self.session.dataTask(with: self.baseURL, completionHandler: { (data, response, error) in
                do {
                    let model: [WelcomeElement] = try JSONDecoder().decode([WelcomeElement].self, from: data ?? Data())
                    observer.onNext(model as! T)
                } catch let error {
                    print(error.localizedDescription)
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
}
