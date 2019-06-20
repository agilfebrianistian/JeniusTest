//
//  DetailViewController.swift
//  JeniusTest
//
//  Created by Agil Febrianistian on 14/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    lazy var presenter: ContactInterface = {
        return ContactsPresenter.init(delegate: self)
    }()

    var contactID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getContact(contactID: contactID)
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddContactViewController", sender: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure do you want to delete this contact?", preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.presenter.deleteContact(contactID: self.contactID)
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddContactViewController" {
            guard let controller = segue.destination as? AddContactViewController else {
                return
            }
            controller.contactID = self.contactID
        }
    }
    
}

extension DetailViewController: ContactDelegate {
    
    func didSuccessUpdateContact(response: ContactSuccessResponseData) {}
    func didFailedUpdateContact(response: NetworkError) {}
    
    func didSuccessAddContact(response: ContactSuccessResponseData) {}
    func didFailedAddContact(response: NetworkError) {}
    
    func didSuccessDeleteContact(response: ContactSuccessResponseData) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didFailedDeleteContact(response: NetworkError) {
        showAlert(title: response.error ?? "", message: response.message ?? "")
    }
    
    func didSuccessGetContact(response: ContactResponseData) {

        nameLabel.text = (response.data.firstName ?? "") + " " + (response.data.lastName ?? "")
        
        ageLabel.text = "\(String(describing: response.data.age ?? 0))"
        contactImage.sd_setImage(with: URL(string: response.data.photo ?? ""), placeholderImage: UIImage(named: "placeholder-avatar"))
    }
    
    func didFailedGetContact(response: NetworkError) {
        showAlert(title: response.error ?? "", message: response.message ?? "")
    }
    
    func didSuccessGetContacts(response: ContactsResponseData) {}
    func didFailedGetContacts(response: NetworkError) {}
}
