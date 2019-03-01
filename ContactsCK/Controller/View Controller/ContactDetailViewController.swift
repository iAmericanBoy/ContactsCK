//
//  ContactDetailViewController.swift
//  ContactsCK
//
//  Created by Dominic Lanzillotta on 3/1/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: - Properties
    var contact: Contact?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Actions

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty,
            let phone = phoneTextField.text,
            let email = emailTextField.text else {return}
        
        if let contact = contact {
            //update contact
            ContactController.shared.update(contact: contact, withName: name, andPhoneNumber: phone, andEmail: email)
            self.navigationController?.popViewController(animated: true)
        } else {
            //save new Conatact
            ContactController.shared.createContact(withName: name, andEmail: email, andPhoneNumber: phone)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Private Functions
    func updateViews() {
        guard let contact = contact else {return}
        self.title = "Contact"
        self.nameTextField.text = contact.name
        self.emailTextField.text = contact.email
        self.phoneTextField.text = contact.phoneNumber
    }
}
