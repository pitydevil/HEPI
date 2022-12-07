//
//  ModelLoader.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/12/22.
//

import UIKit
import FirebaseCore
import FirebaseMLModelDownloader

class ModelLoader {

    //MARK: - Computed object Declaration
    private static var success: NSObjectProtocol? {
        didSet {
            if let value = oldValue {
                NotificationCenter.default.removeObserver(value)
            }
        }
    }
    
    private static var failure: NSObjectProtocol? {
        didSet {
            if let value = oldValue {
              NotificationCenter.default.removeObserver(value)
            }
        }
    }
    
    //MARK: - Add Pet Function
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    ///     - text: set of character/string that would like  to be checked.
    static func downloadModel(named name: String, completion: @escaping (CustomModel?, DownloadError?) -> Void) {
        
      guard FirebaseApp.app() != nil else {
          completion(nil, .firebaseNotInitialized)
          return
      }
        
      guard success == nil && failure == nil else {
          completion(nil, .downloadInProgress)
          return
      }
        
      let conditions = ModelDownloadConditions(allowsCellularAccess: false)
      ModelDownloader.modelDownloader().getModel(name: name, downloadType: .localModelUpdateInBackground, conditions: conditions) { result in
          switch (result) {
              case .success(let customModel):
                      return completion(customModel, nil)
              case .failure(let error):
                completion(nil, .downloadFailed(underlyingError: error))
            }
        }
    }
}
