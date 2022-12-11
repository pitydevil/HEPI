//
//  enumFile.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation

//MARK: - Journal Enum
enum emotionCase : String {
  case Anger   = "0"
  case Fear    = "1"
  case Joy     = "2"
  case Love    = "3"
  case Neutral = "4"
  case Sad     = "5"
}

enum typeError {
  case tidakAdaText, success, inputTidakLengkap, gagalAddData
}

enum summaryError : Error {
    case dataTidakAda(errorMessage: String), tanggalLebihTua(errorMessage: String), tanggalLebihMuda(errorMessage: String), gagalBuatSummary(errorMessage : String)
}

enum summaryGenerate : Error {
    case dataTidakAda(errorMessage: String), success(errorMessage: String)
}

enum AllJournalError: Error {
    case custom(errorMessage: String)
}

//MARK: - Summary Enum
enum datePass {
    case start, end
}

//MARK: - Firebae Download Enum
enum DownloadError: Error {
  case firebaseNotInitialized
  case downloadInProgress
  case downloadFailed(underlyingError: Error)
}
