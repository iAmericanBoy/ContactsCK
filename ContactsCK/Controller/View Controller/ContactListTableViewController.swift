//
//  ContactListTableViewController.swift
//  ContactsCK
//
//  Created by Dominic Lanzillotta on 3/1/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ContactController.shared.fetchContacts { (fetchIsSuccess) in
            if fetchIsSuccess {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

        cell.textLabel?.text = ContactController.shared.contacts[indexPath.row].name
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactToDelete = ContactController.shared.contacts[indexPath.row]
            ContactController.shared.delete(contact: contactToDelete) { (deleteWasSuccess) in
                if deleteWasSuccess {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toDetailVC" {
            guard let index = tableView.indexPathForSelectedRow else {return}
            if let destinationVC = segue.destination as? ContactDetailViewController {
                destinationVC.contact = ContactController.shared.contacts[index.row]
            }
        }
    }
}
