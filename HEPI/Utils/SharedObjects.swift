//
//  Shared Object.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import TensorFlowLiteTaskText
import FirebaseAuth
import FirebaseFirestore

//MARK: - Object Declaration
public let bags = DisposeBag()
public var classifier: TFLNLClassifier?
public let nameKeys = "namaUser"
public let defaults = UserDefaults.standard
public var namaEmailUser = Auth.auth().currentUser?.email
public var uuidUser = Auth.auth().currentUser?.uid
public let db = Firestore.firestore()
public let baseDiaryDir = db.collection("journal").document("user").collection("list")
