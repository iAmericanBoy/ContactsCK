//
//  ContactController.swift
//  ContactsCK
//
//  Created by Dominic Lanzillotta on 3/1/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation


class ContactController {
    
    //MARK: - Singleton
    /// The shared Instance of ContactController.
    static let shared = ContactController()
    
    //MARK: - Source of Truth
    /// The source of truth.
    var contacts: [Contact] = []
    
    //MARK: - CRUD
    /// Creates new Contact.
    /// - parameter name: The name of the new contact (requird)
    /// - parameter email: The email of the new contact
    /// - parameter phoneNumber: The phone number of the new contact
    /// - parameter completion: Handler for when the contact has been created
    /// - parameter isSuccess: Confirms the newly created contact
    func createContact(withName name: String, andEmail email: String, andPhoneNumber phoneNumber: String, completion: (_ isSuccess: Bool) -> Void) {
        let newContact  = Contact(name: name, phoneNumber: phoneNumber, email: email)
        contacts.append(newContact)
    }
    
    /// Read Contacts
    func fetchContacts(completion: @escaping(Bool) -> Void) {
        
    }
    
    /// Updates the contact if the contact exists in the source of truth.
    /// - parameter contact: The contact that needs updating
    /// - parameter name: The updated name of the new contact
    /// - parameter phoneNumber: The updated phoneNumber of the new contact
    /// - parameter andEmail: The updated email of the new contact
    /// - parameter completion: Handler for when the contact has been updated
    /// - parameter isSuccess: Confirms the updated Contact
    func update(contact: Contact, withName name: String, andPhoneNumber phoneNumber: String, andEmail email: String, completion: (_ isSuccess: Bool) -> Void) {
        guard let index = contacts.index(of: contact) else {return}
        contacts[index].name = name
        contacts[index].name = email
        contacts[index].name = phoneNumber
    }
    
    /// Deletes the contact if the contact exists in the source of truth.
    /// - parameter contact: The contact that needs deleting
    /// - parameter completion: Handler for when the contact has been deleted
    /// - parameter isSuccess: Confirms the deleted Contact
    func delete(contact: Contact, completion: (_ isSuccess: Bool) -> Void) {
        guard let index = contacts.index(of: contact) else {return}
        contacts.remove(at: index)
        completion(true)
    }
}
