//
//  NetworkAPI.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import UIKit
import Moya
import Foundation

enum NetworkAPI {
    case getContacts
    case addContact(param: AddContactParameter)
    case deleteContact(contactID: String)
    case getContact(contactID: String)
    case updateContact(param: AddContactParameter, contactID: String)
}

// MARK: - TargetType Protocol Implementation
extension NetworkAPI: NetworkTarget {
    var baseURL: URL {
        return URL(string: NetworkConstant.APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getContacts:
            return "contact"
        case .addContact:
            return "contact"
        case .deleteContact(let contactID):
            return "contact/" + contactID.urlEscapedString
        case .getContact(let contactID):
            return "contact/" + contactID.urlEscapedString
        case .updateContact(_, let contactID):
            return "contact/" + contactID.urlEscapedString
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addContact:
            return .post
        case .updateContact :
            return .put
        case .deleteContact :
            return .delete
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .addContact(let param):
            return .requestJSONEncodable(param)
        case .updateContact(let param, _):
            return .requestJSONEncodable(param)
        default :
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return [:]
    }
    
}

extension NetworkAPI: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType {
        switch self {
        default :
            return .none
        }
    }
}


