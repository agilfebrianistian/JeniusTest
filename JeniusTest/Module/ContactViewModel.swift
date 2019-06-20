//
//  ContactViewModel.swift
//  JeniusTest
//
//  Created by Agil Febrianistian on 14/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

protocol ContactInterface {
    func getContacts()
    func getContact(contactID:String)
    func addContact(form:AddContactParameter)
    func deleteContact(contactID:String)
    func updateContact(form:AddContactParameter, contactID:String)
    
    func isFormValid(parameter: AddContactParameter?) -> Bool
    func getValidationMessage() -> String
}

protocol ContactDelegate: class {
    func didSuccessGetContacts(response: ContactsResponseData)
    func didFailedGetContacts(response: NetworkError)
    func didSuccessGetContact(response: ContactResponseData)
    func didFailedGetContact(response: NetworkError)
    func didSuccessAddContact(response: ContactSuccessResponseData)
    func didFailedAddContact(response: NetworkError)
    func didSuccessDeleteContact(response: ContactSuccessResponseData)
    func didFailedDeleteContact(response: NetworkError)
    func didSuccessUpdateContact(response: ContactSuccessResponseData)
    func didFailedUpdateContact(response: NetworkError)
}

class ContactsPresenter: ContactInterface {
    
    private weak var delegate: ContactDelegate?
    private var addContactParameter: AddContactParameter?
    var validationMessage: String?
    
    init(delegate: ContactDelegate) {
        self.delegate = delegate
    }
    
    func getContacts() {
        let target = NetworkAPI.getContacts
        let future = NetworkFuture<Data>()
        
        let activityData = ActivityData.init(size: CGSize.init(width: 35, height: 35), type: NVActivityIndicatorType.ballGridPulse, color: .gray, backgroundColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        future.request(target: target)
            .done { [weak self] dic in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                let decoder = JSONDecoder()
                let result = try decoder.decode(ContactsResponseData.self, from: dic)
                
                self?.delegate?.didSuccessGetContacts(response: result)
            }.catch { [weak self] error in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self?.delegate?.didFailedGetContacts(response: error as? NetworkError ?? NetworkError())
        }
    }
    
    func getContact(contactID: String){
        let target = NetworkAPI.getContact(contactID: contactID)
        let future = NetworkFuture<Data>()
        
        let activityData = ActivityData.init(size: CGSize.init(width: 35, height: 35), type: NVActivityIndicatorType.ballGridPulse, color: .gray, backgroundColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        future.request(target: target)
            .done { [weak self] dic in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                let decoder = JSONDecoder()
                let result = try decoder.decode(ContactResponseData.self, from: dic)
                
                self?.delegate?.didSuccessGetContact(response: result)
            }.catch { [weak self] error in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self?.delegate?.didFailedGetContact(response: error as? NetworkError ?? NetworkError())
        }
    }
    
    func addContact(form:AddContactParameter) {
        let target = NetworkAPI.addContact(param: form)
        let future = NetworkFuture<Data>()
        
        let activityData = ActivityData.init(size: CGSize.init(width: 35, height: 35), type: NVActivityIndicatorType.ballGridPulse, color: .gray, backgroundColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        future.request(target: target)
            .done { [weak self] dic in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                let decoder = JSONDecoder()
                let result = try decoder.decode(ContactSuccessResponseData.self, from: dic)
                
                self?.delegate?.didSuccessAddContact(response: result)
            }.catch { [weak self] error in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self?.delegate?.didFailedAddContact(response: error as? NetworkError ?? NetworkError())
        }
    }
    
    func deleteContact(contactID: String) {
        let target = NetworkAPI.deleteContact(contactID: contactID)
        let future = NetworkFuture<Data>()
        
        let activityData = ActivityData.init(size: CGSize.init(width: 35, height: 35), type: NVActivityIndicatorType.ballGridPulse, color: .gray, backgroundColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        future.request(target: target)
            .done { [weak self] dic in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                let decoder = JSONDecoder()
                let result = try decoder.decode(ContactSuccessResponseData.self, from: dic)
                
                self?.delegate?.didSuccessDeleteContact(response: result)
            }.catch { [weak self] error in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self?.delegate?.didFailedDeleteContact(response: error as? NetworkError ?? NetworkError())
        }
    }
    
    func updateContact(form:AddContactParameter, contactID: String) {
        let target = NetworkAPI.updateContact(param: form, contactID: contactID)
        let future = NetworkFuture<Data>()
        
        let activityData = ActivityData.init(size: CGSize.init(width: 35, height: 35), type: NVActivityIndicatorType.ballGridPulse, color: .gray, backgroundColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        future.request(target: target)
            .done { [weak self] dic in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                let decoder = JSONDecoder()
                let result = try decoder.decode(ContactSuccessResponseData.self, from: dic)
                
                self?.delegate?.didSuccessUpdateContact(response: result)
            }.catch { [weak self] error in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self?.delegate?.didFailedUpdateContact(response: error as? NetworkError ?? NetworkError())
        }
    }
    
}

extension ContactsPresenter {
    
    func getValidationMessage() -> String {
        return validationMessage ?? ""
    }
    
    private func isEmptyFirstName() -> Bool {
        if let firstname = addContactParameter?.firstName {
            return firstname.trimmingText().isEmpty
        }
        return false
    }
    
    private func isEmptyLastName() -> Bool {
        if let lastname = addContactParameter?.lastName {
            return lastname.trimmingText().isEmpty
        }
        return false
    }
    
    private func isEmptyAge() -> Bool {
        
        if let age = addContactParameter?.age, age > 0 {
            return false
        }
        return true
        
    }
    
    private func isEmptyImageURL() -> Bool {
        if let imageURL = addContactParameter?.photo {
            return imageURL.trimmingText().isEmpty
        }
        return false
    }
    
    private func isValidImageURL() -> Bool {
        if let imageURL = addContactParameter?.photo {
            return imageURL.isValidURL
        }
        return false
    }
    
    func isFormValid(parameter: AddContactParameter?) -> Bool {
        self.addContactParameter = parameter
        
        print(isEmptyAge())
        
        
        if isEmptyFirstName() == true {
            validationMessage = "first name cannot be empty"
            return false
        }
        else if isEmptyLastName() == true {
            validationMessage = "last name cannot be empty"
            return false
        }
        else if isEmptyAge() == true {
            validationMessage = "age must be larger than or equal to 1"
            return false
        }
        else if isEmptyImageURL() == true {
            validationMessage = "image URL cannot be empty"
            return false
        }
        return true
    }
}
