//
//  Extension-String.swift
//  JeniusTest
//
//  Created by Agil Febrianistian on 20/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    internal func trimmingText() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
