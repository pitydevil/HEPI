//
//  Journal.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation

struct Journal: Identifiable, Encodable, Decodable {
    var id    : Int32?
    var titleJournal : String?
    var moodDesc     : String?
    var descJournal  : String?
    var dateCreated  : Date?
    var moodImage    : Data?
}
