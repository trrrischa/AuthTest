//
//  Validator.swift
//  AuthTest
//
//  Created by Ekaterina Nesterova on 14/03/2019.
//  Copyright © 2019 Ekaterina Nesterova. All rights reserved.
//

import Foundation

class Validator: ValidatorProtocol {
    private let emailPredicate: NSPredicate
    private let passwordPredicate: NSPredicate

    init() {
        self.emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        self.passwordPredicate = NSPredicate(format: "SELF MATCHES %@",
                                     "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}$")
    }
    
    func checkEmail(email: String)  throws {
        if email.isEmpty { throw Errors.emailIsEmpty }
        
        try emailMatchesTheMask(email)
    }
    
    func checkPassword(password: String) throws {
        if password.isEmpty { throw Errors.passwordIsEmpty }
        
        try passwordMatchesTheMask(password)
    }
    
    private func emailMatchesTheMask(_ email: String) throws {
        if !self.emailPredicate.evaluate(with: email) {
            throw Errors.emailDoesNotMatchMask
        }
    }

    private func passwordMatchesTheMask(_ password: String) throws {
        if !self.passwordPredicate.evaluate(with: password) {
            throw Errors.passwordDoesNotMatchMask
        }
    }

}
