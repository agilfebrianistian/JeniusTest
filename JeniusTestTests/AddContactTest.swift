//
//  JeniusTestTests.swift
//  JeniusTestTests
//
//  Created by Agil Febrianistian on 20/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import XCTest
@testable import JeniusTest

class AddContactTest: XCTestCase {

    lazy var presenter: ContactInterface = {
        return ContactsPresenter.init(delegate: self)
    }()
    
    let emptyString = ""
    let firstname = "Keroro"
    let lastname = "Gunso"
    let age = "1"
    let zeroAge = "0"
    let imageURL = "https://pbs.twimg.com/profile_images/472442266062045184/YyLIIsD5_400x400.jpeg"


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddContactValidation() {
        
        let testWithoutUsername = AddContactParameter.init(firstName: emptyString,
                                                           lastName: lastname,
                                                           age: Int(age),
                                                           photo: imageURL)

        XCTAssertEqual(presenter.isFormValid(parameter:testWithoutUsername), false)
        
        let testWithoutLastname = AddContactParameter.init(firstName: firstname,
                                                           lastName: emptyString,
                                                           age: Int(age),
                                                           photo: imageURL)
        
        XCTAssertEqual(presenter.isFormValid(parameter:testWithoutLastname), false)

        let testWithoutImageURL = AddContactParameter.init(firstName: firstname,
                                                           lastName: lastname,
                                                           age: Int(age),
                                                           photo: emptyString)
        
        XCTAssertEqual(presenter.isFormValid(parameter:testWithoutImageURL), false)

        let testSuccess = AddContactParameter.init(firstName: firstname,
                                                           lastName: lastname,
                                                           age: Int(age),
                                                           photo: imageURL)
        
        XCTAssertEqual(presenter.isFormValid(parameter:testSuccess), true)

    }
    
    
    func testAgeValidation() {
    
        let testWithoutAge = AddContactParameter.init(firstName: firstname,
                                                      lastName: lastname,
                                                      age: Int(emptyString),
                                                      photo: imageURL)
        
        XCTAssertEqual(presenter.isFormValid(parameter:testWithoutAge), false)
        
        let testZeroAge = AddContactParameter.init(firstName: firstname,
                                                      lastName: lastname,
                                                      age: Int(emptyString),
                                                      photo: imageURL)
        
        XCTAssertEqual(presenter.isFormValid(parameter:testZeroAge), false)

        
    }

}

extension AddContactTest: ContactDelegate {
    func didSuccessUpdateContact(response: ContactSuccessResponseData) {}
    func didFailedUpdateContact(response: NetworkError) {}
    
    func didSuccessAddContact(response: ContactSuccessResponseData) {}
    func didFailedAddContact(response: NetworkError) {}
    
    func didSuccessDeleteContact(response: ContactSuccessResponseData) {}
    func didFailedDeleteContact(response: NetworkError) {}
    
    func didSuccessGetContacts(response: ContactsResponseData) {}
    func didFailedGetContacts(response: NetworkError) {}
    
    func didSuccessGetContact(response: ContactResponseData) {}
    func didFailedGetContact(response: NetworkError) {}
    
}
