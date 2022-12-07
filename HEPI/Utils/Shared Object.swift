//
//  Shared Object.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import TensorFlowLiteTaskText

//MARK: - Object Declaration
public let bags = DisposeBag()
public var classifier: TFLNLClassifier?
public let nameKeys = "namaUser"
public let defaults = UserDefaults.standard
