//
//  enumFile.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation

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

enum datePass {
    case start, end
}
