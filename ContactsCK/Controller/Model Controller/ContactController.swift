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
    /// The shared Instance of ContactController
    static let shared = ContactController()
    
    //MARK: - Source of Truth
    var contacts: [Contact] = []
    
    //MARK: - CRUD
    /// Create Contact
    /// - parameter name: The name of the new contact (requird)
    /// - parameter email: The email of the new contact
    /// - parameter phoneNumber: The phone number of the new contact
    func createContact(withName name: String, andEmail email: String, andPhoneNumber phoneNumber: String) {
        let newContact  = Contact(name: name, phoneNumber: phoneNumber, email: email)
        
        contacts.append(newContact)
    }
    
    /// Read Contacts
    func fetchContacts(completion: @escaping(Bool) -> Void) {
        
    }
    
    /// Updates the contact if the contact exists in the source of truth
    /// - parameter contact: The contact that needs updating
    /// - parameter name: The updated name of the new contact
    /// - parameter phoneNumber: The updated phoneNumber of the new contact
    /// - parameter andEmail: The updated email of the new contact
    func update(contact: Contact, withName name: String, andPhoneNumber phoneNumber: String, andEmail email: String) {
        guard let index = contacts.index(of: contact) else {return}
        contacts[index].name = name
        contacts[index].name = email
        contacts[index].name = phoneNumber
    }
    
    /// Deletes the contact if the contact exists in the source of truth
    /// - parameter contact: The contact that needs deleting
    func delete(contact: Contact) {
        guard let index = contacts.index(of: contact) else {return}
        contacts.remove(at: index)
    }
}
