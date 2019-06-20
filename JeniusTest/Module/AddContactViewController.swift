//
//  AddContactViewController.swift
//  JeniusTest
//
//  Created by Agil Febrianistian on 19/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import UIKit
import SDWebImage

class AddContactViewController: UIViewController {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var imageURLTextfield: UITextField!
    
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    
    lazy var presenter: ContactInterface = {
        return ContactsPresenter.init(delegate: self)
    }()
    
    var contactID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if contactID != nil {
            self.title = "Edit Contact"
            presenter.getContact(contactID: contactID!)
        }
        
    }
    
    @IBAction func checkImageButtonTapped(_ sender: Any) {
        
        if (imageURLTextfield.text != "" && imageURLTextfield.text!.isValidURL){
            contactImage.sd_setImage(with: URL(string: imageURLTextfield.text ?? ""), placeholderImage: UIImage(named: "placeholder-avatar"))
        }
        else {
            showAlert(title: "", message: "please input valid image URL")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let form = AddContactParameter.init(firstName: firstNameTextfield.text,
                                            lastName: lastNameTextfield.text,
                                            age: Int(ageTextfield.text ?? "0"),
                                            photo: imageURLTextfield.text)
        
        if presenter.isFormValid(parameter: form) == true {
            if contactID != nil {
                presenter.updateContact(form: form, contactID: contactID!)
            }
            else {
                presenter.addContact(form: form)
            }
        }
        else {
            showAlert(title: "", message: presenter.getValidationMessage())
        }
    }
}

extension AddContactViewController: ContactDelegate {
    func didSuccessUpdateContact(response: ContactSuccessResponseData) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didFailedUpdateContact(response: NetworkError) {
        showAlert(title: response.error ?? "", message: response.message ?? "")
    }
    
    func didSuccessAddContact(response: ContactSuccessResponseData) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didFailedAddContact(response: NetworkError) {
        showAlert(title: response.error ?? "", message: response.message ?? "")
    }
    
    func didSuccessDeleteContact(response: ContactSuccessResponseData) {}
    func didFailedDeleteContact(response: NetworkError) {}
    
    func didSuccessGetContacts(response: ContactsResponseData) {}
    func didFailedGetContacts(response: NetworkError) {}
    
    func didSuccessGetContact(response: ContactResponseData) {
        
        firstNameTextfield.text = response.data.firstName ?? ""
        lastNameTextfield.text = response.data.lastName ?? ""
        ageTextfield.text = "\(String(describing: response.data.age ?? 0))"
        imageURLTextfield.text = response.data.photo ?? ""
        
        contactImage.sd_setImage(with: URL(string: response.data.photo ?? ""), placeholderImage: UIImage(named: "placeholder-avatar"))
    }
    
    func didFailedGetContact(response: NetworkError) {
        showAlert(title: response.error ?? "", message: response.message ?? "")
    }
    
}
