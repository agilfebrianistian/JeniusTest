//
//  Contact.swift
//  JeniusTest
//
//  Created by Agil Febrianistian on 14/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation

struct ContactsResponseData: Codable {
    let message: String?
    let data: [ContactResponse]
}

struct ContactResponseData: Codable {
    let message: String?
    let data: ContactResponse
}

struct ContactSuccessResponseData: Codable {
    let message: String?
}

struct ContactResponse: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let age: Int?
    let photo: String?
}
