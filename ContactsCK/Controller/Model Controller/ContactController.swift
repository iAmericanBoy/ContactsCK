//
//  ContactController.swift
//  ContactsCK
//
//  Created by Dominic Lanzillotta on 3/1/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit


class ContactController {
    
    //MARK: - Singleton
    /// The shared Instance of ContactController.
    static let shared = ContactController()
    
    //MARK: - Source of Truth
    /// The source of truth.
    var contacts: [Contact] = []
    
    //MARK: - Properties
    /// The private Database of the User.
    fileprivate let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - CRUD
    /// Creates new Contact.
    /// - parameter name: The name of the new contact (requird).
    /// - parameter email: The email of the new contact.
    /// - parameter phoneNumber: The phone number of the new contact.
    /// - parameter completion: Handler for when the contact has been created.
    /// - parameter isSuccess: Confirms the new contact was created.
    func createContact(withName name: String, andEmail email: String, andPhoneNumber phoneNumber: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let newContact  = Contact(name: name, phoneNumber: phoneNumber, email: email)
        guard let record = CKRecord(contact: newContact) else {completion(false); return}
        
        saveChangestoCK(contactsToUpdate: [record], contactsToDelete: []) { (isSuccess, savedRecords, _) in
            if isSuccess {
                guard let record = savedRecords?.first , record.recordID == newContact.recordID,
                    let savedRecord = Contact(record: record) else {
                    completion(false)
                    return
                }
                self.contacts.append(savedRecord)
                completion(true)
            }
        }
    }
    
    /// Fetches the contacts and updates the source of Truth
    func fetchContacts(completion: @escaping(Bool) -> Void) {
        fetchRecordsFromCK { (isSuccess, records) in
            if isSuccess {
                guard let contacts = records?.compactMap({ Contact(record: $0) }) else {
                    completion(false)
                    return
                }
                self.contacts += contacts
            }
        }
    }
    
    /// Updates the contact if the contact exists in the source of truth.
    /// - parameter contact: The contact that needs updating.
    /// - parameter name: The updated name of the new contact.
    /// - parameter phoneNumber: The updated phoneNumber of the new contact.
    /// - parameter andEmail: The updated email of the new contact.
    /// - parameter completion: Handler for when the contact has been updated.
    /// - parameter isSuccess: Confirms the contact was updated.
    func update(contact: Contact, withName name: String, andPhoneNumber phoneNumber: String, andEmail email: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        contact.name = name
        contact.email = email
        contact.phoneNumber = phoneNumber
        
        guard let record = CKRecord(contact: contact) else {completion(false); return}
        
        saveChangestoCK(contactsToUpdate: [record], contactsToDelete: []) { (isSuccess, savedRecord, _) in
            if isSuccess {
                guard let record = savedRecord?.first , record.recordID == contact.recordID,
                    let index = self.contacts.index(of: contact),
                    let updatedContact = Contact(record: record) else {
                        completion(false)
                        return
                }
                self.contacts.remove(at: index)
                self.contacts.insert(updatedContact, at: index)
                completion(true)
            }
        }
    }
    
    /// Deletes the contact if the contact exists in the source of truth.
    /// - parameter contact: The contact that needs deleting
    /// - parameter completion: Handler for when the contact has been deleted
    /// - parameter isSuccess: Confirms the contact was deleted.
    func delete(contact: Contact, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let record = CKRecord(contact: contact) else {completion(false); return}
        
        saveChangestoCK(contactsToUpdate: [], contactsToDelete: [record]) { (isSuccess, _, deletedRecordIDs) in
            if isSuccess {
                guard let recordID = deletedRecordIDs?.first , recordID == contact.recordID, let index = self.contacts.index(of: contact)else {
                    completion(false)
                    return
                }
                self.contacts.remove(at: index)
                completion(true)
            }
        }
    }
    
    //MARK: - CloudKit
    /// Updates and Deletes changes to CloudKit.
    /// - parameter contactsToUpdate: Contacts that where updated or created as Records.
    /// - parameter contactsToDelete: Contacts that need deleted as Records.
    /// - parameter completion: Handler for when the contact has been deleted.
    /// - parameter isSuccess: Confirms that the change has synced to CloudKit.
    /// - parameter savedRecords: The saved records (can be nil).
    /// - parameter deletedRecordIDs: The deleted recordIds (can be nil).
    fileprivate func saveChangestoCK(contactsToUpdate update: [CKRecord], contactsToDelete delete: [CKRecord], completion: @escaping (_ isSuccess: Bool,_ savedRecords: [CKRecord]?, _ deletedRecordIDs: [CKRecord.ID]?) -> Void) {
        let recordIDsOfRecordsToDelete = delete.compactMap({ $0.recordID})
        let operation = CKModifyRecordsOperation(recordsToSave: update, recordIDsToDelete: recordIDsOfRecordsToDelete)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (savedRecords,deletedRecords,error) in
            if let error = error {
                print("An Error updating CK has occured. \(error), \(error.localizedDescription)")
                completion(false, savedRecords,deletedRecords)
                return
            }
            guard let saved = savedRecords, let deleted = deletedRecords else {completion(false,savedRecords,deletedRecords); return}
                completion(true,saved,deleted)
            
        }
        privateDB.add(operation)
    }
    
    /// Update and Deletes changes to CloudKit.
    /// - parameter completion: Handler for the feched Records.
    /// - parameter isSuccess: Confirms that records where able to be fetched.
    /// - parameter fetchedRecords: The fetched Records (can be nil).
    fileprivate func fetchRecordsFromCK(completion: @escaping(_ isSuccess: Bool,_ fetchedRecords:[CKRecord]?)-> Void ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactMS.typeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("An Error fetching record from Ck has occured: \(error), \(error.localizedDescription)")
                completion(false, records)
                return
            }
            guard let fetchedRecords = records else {completion(false,records); return}
            completion(true,fetchedRecords)
        }
    }
}
