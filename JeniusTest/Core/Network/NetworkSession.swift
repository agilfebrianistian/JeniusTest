//
//  NetworkSession.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 06/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation

enum Keychain: String {
    case loginToken
    func toString() -> String {
        return self.rawValue
    }
}

class NetworkSession {
    static var sharedInstance: NetworkSession = NetworkSession()
    
    var loginToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Keychain.loginToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keychain.loginToken.rawValue)
        }
    }
    
    func cacheUserData() {
        self.loginToken = ""
    }
    
    func clearData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }

}
