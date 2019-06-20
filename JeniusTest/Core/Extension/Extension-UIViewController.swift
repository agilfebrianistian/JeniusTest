//
//  Extension-UIViewController.swift
//  JeniusTest
//
//  Created by Agil Febrianistian on 19/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
