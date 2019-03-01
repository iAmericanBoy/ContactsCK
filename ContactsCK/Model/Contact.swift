//
//  Contact.swift
//  ContactsCK
//
//  Created by Dominic Lanzillotta on 3/1/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

/// The MagicStrings for the ContactClass
struct ContactMS {
    /// "contact"
    static let typeKey = "contact"
    /// "name"
    fileprivate static let nameKey = "name"
    /// "email"
    fileprivate static let emailKey = "email"
    /// "phone"
    fileprivate static let phoneKey = "phone"
}

class Contact {
    var name: String
    var phoneNumber: String
    var email: String
    let recordID: CKRecord.ID
    
    init(name: String, phoneNumber: String = "", email: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = recordID
    }
    
    init?(record: CKRecord) {
        guard let name = record[ContactMS.nameKey] as? String,
            let email = record[ContactMS.emailKey] as? String,
            let phone = record[ContactMS.phoneKey] as? String else {return nil}
        
        self.name = name
        self.email = email
        self.phoneNumber = phone
        self.recordID = record.recordID
    }
}

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactMS.typeKey, recordID: contact.recordID)
        
        setValue(contact.name, forKey: ContactMS.nameKey)
        setValue(contact.email, forKey: ContactMS.emailKey)
        setValue(contact.phoneNumber, forKey: ContactMS.phoneKey)
    }
}
