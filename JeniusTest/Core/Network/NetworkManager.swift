//
//  NetworkManager.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static var sharedInstance: NetworkManager = NetworkManager()
    static var networkApiDomain: String {
        return NetworkConstant.APIConstant.baseURL
    }
    
    let manager = SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: nil
    )
    
    var token: String {
        let userDefault = UserDefaults.standard
        let token = userDefault.string(forKey: Keychain.loginToken.rawValue)
        return token ?? ""
    }
}


